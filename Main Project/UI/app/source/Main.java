import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import kinect4WinSDK.Kinect; 
import kinect4WinSDK.SkeletonData; 
import java.awt.Rectangle; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Main extends PApplet {




ArrayList <SkeletonData> bodies;

Kinect kinect;
KinectMov kinectmov;

int bgColor = color(255, 100, 50);
Configuration cfg;
ArrayList<Word> fears;
ArrayList<Word> strengths;
boolean centered;
Board board;
boolean creatingBoard;
boolean aligningFears;
boolean disaligningFears;
boolean aligningStrengths;

public void settings() {
  fullScreen(P2D);
  //size(1024,768,P2D);
}

public void setup() {
  background(bgColor);
  
  centered = false;

  cfg = new Configuration();
  fears = new ArrayList<Word>();
  strengths = new ArrayList<Word>();
  creatingBoard = true;
  aligningFears = true;
  disaligningFears = false;
  aligningStrengths = false;
  this.bgColor = this.cfg.BackgroundColor;
  if (this.cfg.SensorType == "KINECT") {
    kinect = new Kinect(this);
    kinectmov = new KinectMov();
    bodies = new ArrayList<SkeletonData>();
    total();
  }
}

  int msPreviousDisalign = 0;


public void draw() {
  // Background & motion blur
  fill(0);
  noStroke();
  
  if (creatingBoard) {
    board = new Board(cfg);
    creatingBoard = false;
  }
  
  if (aligningFears) {
    background(bgColor);
    board.alignAllFears();
    if (board.allFearsAligned()) {
      aligningFears = false;
      disaligningFears = true;
    }
  }
  
  if (disaligningFears) {
    background(this.cfg.BackgroundColor);
    int force = 0;
    if ((millis() - msPreviousDisalign) > this.cfg.DisalignIntervalMs) {
      msPreviousDisalign = millis();
      force = getForce();
    }
    if (!board.disalignWord(force)) {
      disaligningFears = false;
      aligningStrengths = true;
    }
    board.drawAllFears();
  }
  
  if (aligningStrengths) {
    background(bgColor);
    board.alignAllStrengths();
    if (board.allStrengthsAligned()) {
      //aligningStrengths = false;
    }
  }
  
}

public int getForce() {
  int force = 0;
  switch(this.cfg.SensorType) {
    case "RANDOM":
      force = (int)random(0, 6);
      break;
    case "KINECT":
      force = kinectmov.cons;
      break;
    case "CAMERA":
      // TODO
      break;
  }
  return force;
}

public void total() {
  kinectmov.total();
  thread("total"); 
}

public void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

public void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID || 0 == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

public void moveEvent(SkeletonData _b, SkeletonData _a)
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}
class Board {
  PVector Size;
  ArrayList<Word> Fears;
  ArrayList<Word> Strengths;
  Word currentWord;
  Configuration Config;
  
  public Board(Configuration config) {
    this.Fears = new ArrayList<Word>();
    this.Strengths = new ArrayList<Word>();
    this.Config = config;
    for (String fear : config.Fears) {//fears creation to be replaced with data input
      int rndm = (int)random(0, this.Config.FearsColors.size());
      if (rndm >= this.Config.FearsColors.size()) rndm = this.Config.FearsColors.size() - 1;
      int wColor = color(this.Config.FearsColors.get(rndm));
      this.Fears.add(new Word(fear, this.Config.FontName, this.Config.FontSize, this.Fears, wColor, this.Config.LocationType));
    }
    for (String strength : config.Strengths) {//same with strenghts
      int rndm = (int)random(0, this.Config.StrengthsColors.size());
      if (rndm >= this.Config.StrengthsColors.size()) rndm = this.Config.StrengthsColors.size() - 1;
      int wColor = color(this.Config.StrengthsColors.get(rndm));
      this.Strengths.add(new Word(strength, this.Config.FontName, this.Config.FontSize, this.Strengths, wColor, this.Config.LocationType));
    }
    
    switch (this.Config.LocationType) {
      case "RANDOM":
        break;
      case "FIXED":
        alignInRows(this.Fears);
        alignInRows(this.Strengths);
        break;
    }
  }
  
  private void getNextAlignedWord() {
    if (this.currentWord != null)
      this.Fears.remove(this.currentWord);
    this.currentWord = null;
    if (this.Fears.size() == 0) return;
    boolean aligned = false;
    while (!aligned) {
      int randomIndex = (int) random(0, this.Fears.size() - 1);
      if (!this.Fears.get(randomIndex).isCompletelyDisaligned()) {
        this.currentWord = this.Fears.get(randomIndex);
        aligned = true;
      }
    }
  }
  
  private void alignAllFears() {
    for (Word fear : this.Fears) {
      fear.alignParticles();
    }
    this.drawAllFears();
  }
  
  private void alignAllStrengths() {
    for (Word strength : this.Strengths) {
      strength.alignParticles();
    }
    this.drawAllStrengths();
  }
  
  // Returns true when it can continue disaligning, else false (if currentWord is null after getNextAlignedWord, there are no more available words to disalign).
  public boolean disalignWord(int force) {
    if (this.currentWord == null || this.currentWord.isCompletelyDisaligned()) this.getNextAlignedWord();
    if (this.currentWord == null) return false;
    this.currentWord.disalignParticles(force, Config.DisalignConversionFactor);
    return true;
  }
    
  public boolean allFearsAligned() {
    boolean allAligned = true;
    for (Word w : this.Fears) {
      if (!w.allParticlesAligned()) return false;
    }
    return allAligned;
  }
  
  public boolean allStrengthsAligned() {
    boolean allAligned = true;
    for (Word w : this.Strengths) {
      if (!w.allParticlesAligned()) return false;
    }
    return allAligned;
  }
  
  public void drawAllFears() {
    for (Word fear : this.Fears) {
      fear.draw();
    }
  }
  
  public void drawAllStrengths() {
    for (Word strength : this.Strengths) {
      strength.draw();
    }
  }
  private void alignInRows (ArrayList<Word> wordsToAlign){//new words positioning algorithmn
    float wordHeight = 0;
    ArrayList<Row> rows = new ArrayList<Row>();
    for (Word w : wordsToAlign) {
      if (w.Size.y > wordHeight) wordHeight = w.Size.y;
    }
    for (int i = 0; i < height/wordHeight; i++) {
      rows.add(new Row(i));
    }
    
    for (Word wordToAdd : wordsToAlign) {
      Row potentialRow = rows.get(PApplet.parseInt(random((rows.size()))));
      while (potentialRow.wordAmount() == 2) {//max 2 por row
        potentialRow = rows.get(PApplet.parseInt(random( (rows.size()))));
      }
       potentialRow.addWord(wordToAdd);
    }
    for (Row r : rows) {
      r.mergeColumn(wordHeight);
    } 
  }
}
class Configuration {
  public String AnimationType = "ANIMACION1";
  public String SensorType = "KINECT";
  public String CameraName = "";
  public Integer BackgroundColor = color(220, 230, 240);
  public ArrayList<String> Fears = new ArrayList<String>();
  public ArrayList<Integer> FearsColors = new ArrayList<Integer>(); // colors are integers, add new item with color(r,g,b)
  public ArrayList<String> Strengths = new ArrayList<String>();
  public ArrayList<Integer> StrengthsColors = new ArrayList<Integer>(); // colors are integers, add new item with color(r,g,b)
  public PVector ProjectorResolution = new PVector(800,600);
  public String ProjectorName = "";
  public String FontName = "Arial";
  public int FontSize = 48;
  public float DisalignConversionFactor = 55.5f;
  public int DisalignIntervalMs = 500;
  public String LocationType = "RANDOM";
  
  public Configuration() {
    File[] files = listFiles(sketchPath());
    for (int i = 0; i < files.length; i++) {
      File f = files[i];
      if (f.getName().equals("cfg.txt")) {
        BufferedReader reader = createReader(f.getName());
        boolean read = true;
        while (read) {
          String line = "";
          try {
            line = reader.readLine();
          } catch (Exception ex) {
            line = null;
          }
          if (line == null || line.equals("")) {
            read = false;
          } else {
            // Process line
            String[] keyValue = line.split("=");
            switch(keyValue[0]) {
              case "AnimationType":
                this.AnimationType = keyValue[1];
                break;
              case "SensorType":
                this.SensorType = keyValue[1];
                break;
              case "CameraName":
                this.CameraName = keyValue[1];
                break;
              case "ProjectorName":
                this.ProjectorName = keyValue[1];
                break;
              case "ProjectorResolution":
                String[] coord = splitTokens(keyValue[1], ",");
                this.ProjectorResolution = new PVector(PApplet.parseInt(coord[0]), PApplet.parseInt(coord[1]));
                break;
              case "Fears":
                String[] fears = keyValue[1].split(";");
                for (String w : fears) {
                  this.Fears.add(w);
                }
                break;
              case "FearsColors":
                String[] fearsColors = splitTokens(keyValue[1], "|");
                for (String colorRGB : fearsColors) {
                  String[] fearColorComps = splitTokens(colorRGB, ";");
                  this.FearsColors.add(color(PApplet.parseInt(fearColorComps[0]), PApplet.parseInt(fearColorComps[1]), PApplet.parseInt(fearColorComps[2])));
                }
                break;
              case "Strengths":
                String[] strengths = keyValue[1].split(";");
                for (String w : strengths) {
                  this.Strengths.add(w);
                }
                break;
              case "StrengthsColors":
                String[] strengthsColors = splitTokens(keyValue[1], "|");
                for (String colorRGB : strengthsColors) {
                  String[] strengthColorComps = splitTokens(colorRGB, ";");
                  this.StrengthsColors.add(color(PApplet.parseInt(strengthColorComps[0]), PApplet.parseInt(strengthColorComps[1]), PApplet.parseInt(strengthColorComps[2])));
                }
                break;
              case "FontName":
                this.FontName = keyValue[1];
                break;
              case "FontSize":
                this.FontSize = PApplet.parseInt(keyValue[1]);
                break;
              case "DisalignConversionFactor":
                this.DisalignConversionFactor = PApplet.parseFloat(keyValue[1]);
                break;
              case "DisalignIntervalMs":
                this.DisalignIntervalMs = PApplet.parseInt(keyValue[1]);
                break;
              case "BackgroundColor":
                String[] backgroundColorComps = keyValue[1].split(";");
                this.BackgroundColor = color(PApplet.parseInt(backgroundColorComps[0]), PApplet.parseInt(backgroundColorComps[1]), PApplet.parseInt(backgroundColorComps[2]));
                break;
              case "LocationType":
                this.LocationType = keyValue[1];
                break;
            }
          }
        }
        break;
      }
    }
  }
}
public class KinectMov {
  private int time = 0;
  public int cons = 0;
  
  private final int[] partes = {7,11,13,17};
  
  private int[] skely = new int[24];
  private int[] skelx = new int[24];

  public final void total() {
    int todo = movimiento();
    if (todo != 0) {cons = todo;}
  }
  
  private int auxiliar() {
    int todo = 0;
    for(int l = 0; l < bodies.size() ;l++) {
      SkeletonData _s = bodies.get(l);
      for (int p = 0; p < 4; p++) {
        if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],60)) {
          if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],50)) {
            if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],40)) {
              if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],30)) {
                if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],20)) {
                } else {todo = todo + 2; p = 5;}
              } else {todo = todo + 3; p = 5;}
            } else {todo = todo + 4; p = 5;}
          } else {todo = todo + 5; p = 5;}
        } else {todo = todo + 6; p = 5;}
      }
      randomSeed(hour()*10000+minute()*100+second());
      todo = todo + (int)random(0,2);
    }
    return todo;
  }
  
  
  private int movimiento() {
    if (time <= millis()-1000 && time != 0) {time = 0; return auxiliar();}
    
    // Guardar posici\u00f3n de cada parte del cuerpo
    while (time == 0) {
      for (int l = 0; l<bodies.size(); l++) {
      SkeletonData _s = bodies.get(l);
      skelx[l*4]=(int)pos(_s,partes[0],'x'); skely[l*4]=(int)pos(_s,partes[0],'y');
      skelx[l*4+1]=(int)pos(_s,partes[1],'x'); skely[l*4+1]=(int)pos(_s,partes[1],'y');
      skelx[l*4+2]=(int)pos(_s,partes[2],'x'); skely[l*4+2]=(int)pos(_s,partes[2],'y');
      skelx[l*4+3]=(int)pos(_s,partes[3],'x'); skely[l*4+3]=(int)pos(_s,partes[3],'y');
      }
      time = millis();
    }
    //int time = millis();
    //while (time+1000 < millis()){};// Espera un segundo
    return 0;
   } // Detecta si el usuario se movio de la posici\u00f3n indicada con cada parte del cuerpo
    
  
  private float pos(SkeletonData _s, int b, char c) { // Toma la posici\u00f3n del cuerpo en cuestion
    if (c == 'x') {return _s.skeletonPositions[b].x*width;}
    if (c == 'y') {return _s.skeletonPositions[b].y*height;}
    if (c == 'z') {return _s.skeletonPositions[b].z*-8000;}
    else return Kinect.NUI_SKELETON_POSITION_NOT_TRACKED;
  }
  
  private boolean det(SkeletonData _s, int s, int x, int y, int d) { // Detecta si el cuerpo est\u00e1 en un lugar especif\u00edco, o en un radio
    if (pos(_s, s, 'x') >= x-d && pos(_s, s, 'x') <= x+d) {
          if (pos(_s, s, 'y') >= y-d && pos(_s, s, 'y') <= y+d) {
            return true;
          } else {return false;}
        } else {return false;}
  }
}
class Particle {
  boolean drawAsPoints = false;
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  public PVector target = new PVector(0, 0);

  float closeEnoughTarget = 50;
  float maxSpeed = 5.0f;
  float maxForce = 0.1f;
  float particleSize = 5;
  public boolean isKilled = false;
  public boolean isDisaligning = false;

  int startColor = color(0);
  int targetColor = color(0);
  float colorWeight = 0;
  float colorBlendRate = 0.025f;

  Particle(boolean pDrawAsPoints) {
    this.drawAsPoints = pDrawAsPoints;
  }
  
  Particle(boolean pDrawAsPoints, int x, int y) {
    this.drawAsPoints = pDrawAsPoints;
    this.target.x = x;
    this.target.y = y;
    this.pos.x = width/2;
    this.pos.y = height/2;
  }
  
  Particle(boolean pDrawAsPoints, int x, int y, int particleColor) {
    this.drawAsPoints = pDrawAsPoints;
    this.target.x = x;
    this.target.y = y;
    this.pos.x = width/2;
    this.pos.y = height/2;
    this.targetColor = particleColor;
  }

  public void move() {
    // Check if particle is close enough to its target to slow down
    float proximityMult = 1.0f;
    float distance = dist(this.pos.x, this.pos.y, this.target.x, this.target.y);
    if (distance < this.closeEnoughTarget) {
      proximityMult = distance/this.closeEnoughTarget;
    }

    // Add force towards target
    PVector towardsTarget = new PVector(this.target.x, this.target.y);
    towardsTarget.sub(this.pos);
    towardsTarget.normalize();
    towardsTarget.mult(this.maxSpeed*proximityMult);

    PVector steer = new PVector(towardsTarget.x, towardsTarget.y);
    steer.sub(this.vel);
    steer.normalize();
    steer.mult(this.maxForce);
    this.acc.add(steer);

    // Move particle
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }

  public void draw() {
    if (!this.isKilled) {
      // Draw particle
      int currentColor = lerpColor(this.startColor, this.targetColor, this.colorWeight);
      if (drawAsPoints) {
        stroke(currentColor);
        point(this.pos.x, this.pos.y);
      } else {
        noStroke();
        fill(currentColor);
        ellipse(this.pos.x, this.pos.y, this.particleSize, this.particleSize);
      }
  
      // Blend towards its target color
      if (this.colorWeight < 1.0f) {
        this.colorWeight = min(this.colorWeight+this.colorBlendRate, 1.0f);
      }
    }
  }

  public void kill() {
    if (! this.isKilled) {
      // Set its target outside the scene
      //PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
      //this.target.x = randomPos.x;
      //this.target.y = randomPos.y;

      // Begin blending its color to black
      this.startColor = lerpColor(this.startColor, this.targetColor, this.colorWeight);
      this.targetColor = color(0);
      this.colorWeight = 0;

      this.isKilled = true;
    }
  }
  
  public boolean isAligned() {
    if (Math.abs(this.pos.x - this.target.x) < 2 && Math.abs(this.pos.y - this.target.y) < 2)
      return true;
    return false;
  }
  
  public boolean isOutOfBoundaries() {
    if (this.pos == null) return false;
    return ((this.pos.x < 0 || this.pos.x > width) && (this.pos.y < 0 || this.pos.y > height));
  }
  
  public boolean isTargetOutOfBoundaries() {
    if (this.target == null) return false;
    return ((this.target.x <= 0 || this.target.x >= width) || (this.target.y <= 0 || this.target.y >= height));
  }
  
  public void disalign() {
    // Set target out of screen boundaries
    if (!this.isTargetOutOfBoundaries() && !isDisaligning) {
      isDisaligning = true;
      // Find nearest border
      boolean left = true;
      boolean top = true;
      if (this.pos.x >= width / 2) left = false;
      if (this.pos.y >= height / 2) top = false;
      
      float dx = 0;
      float dy = 0;
      if (left && top) {
        dx = this.pos.x;
        dy = this.pos.y;
        if (dx <= dy) {
          this.target.x = -random(0, 25);
          this.target.y = this.pos.y + random(-25, 25);
        } else {
          this.target.x = this.pos.x + random(-25, 25);
          this.target.y = -random(0, 25);
        }
      } else if (left && !top) {
        dx = this.pos.x;
        dy = height - this.pos.y;
        if (dx <= dy) {
          this.target.x = -random(0, 25);
          this.target.y = this.pos.y + random(-25, 25);
        } else {
          this.target.x = this.pos.x + random(-25, 25);
          this.target.y = height + random(0, 25);
        }
      } else if (!left && top) {
        dx = width - this.pos.x;
        dy = this.pos.y;
        if (dx <= dy) {
          this.target.x = width + random(0, 25);
          this.target.y = this.pos.y + random(-25, 25);
        } else {
          this.target.x = this.pos.x + random(-25, 25);
          this.target.y = -random(0, 25);
        }
      } else if (!left && !top) {
        dx = width - this.pos.x;
        dy = height - this.pos.y;
        if (dx <= dy) {
          this.target.x = width + random(0, 25);
          this.target.y = this.pos.y + random(-25, 25);
        } else {
          this.target.x = this.pos.x + random(-25, 25);
          this.target.y = height + random(0, 25);
        }
      }
    }
    this.move();
    if (this.isAligned()) this.kill();
  }
}
class Row {
  protected ArrayList<Word> Words = new ArrayList<Word>();//serian 2 por row por ahora
  public int numeroDeRow;
  public Row(int n){//contructor
    this.numeroDeRow=n;
  }
  public void addWord(Word r) {
    Word aux ;
    if (this.Words.size() == 0) {
      agregarRectangulo(r,"rnd");
    } 
    else if (this.Words.size() == 1) {
      aux = Words.get(0);
      if (aux.columna().equals("der")) {
        agregarRectangulo(r, "izq");
      } else {
        agregarRectangulo(r, "der");
      }
    } else {
      println("Error AgregarPalabra");
    }
  }
  public String columnaRandom() {
    float i= random(1.99f);//0 o 1(1.99 por las dudas no sea cosa que tire un 2)
    if (i > 0.5f) {
      return "der";
    } else {
      return "izq";
    }
  }
  public int wordAmount() {
    return this.Words.size();
  }
  
  private void agregarRectangulo(Word rec, String pos) {
     if(pos.equals("rnd")){
       rec.ponerEnColumna(columnaRandom());
     }
     else{
       rec.ponerEnColumna(pos);
     }
     rec.darEspacioParaRandom(0-PApplet.parseInt(rec.Largo()), 0,"der");
     rec.posicionarEnRow(this.numeroDeRow);
     
     rec.updateParticlesTarget();
     this.Words.add(rec);
  }
  public void mergeColumn(float wordHeight) {
    if (this.wordAmount() == 1) {
      Word rectangulo=this.Words.get(0);
      String posFinal = "der";
      if (rectangulo.columna().equals("der")) posFinal = "izq";
      rectangulo.darEspacioParaRandom(PApplet.parseInt(wordHeight), 0, posFinal);
    }
  }
}


class Word {
  int pixelSteps = 1;
  public String Text;
  public PVector TopLeftPos = new PVector(0,0);
  public PVector Size;
  public int FontSize;
  public String FontName;
  public ArrayList<Particle> ComponentParticles = new ArrayList<Particle>();
  public Boolean IsAligned = true;
  private String col;//izq der
  private PVector EspacioRandomizable;
  int AlignPercentage = 100;
  int buffer = 20;
  Rectangle rectangle;
  int wordColor;
  
  public Word(String wordText, String wordFontName, int wordFontSize, ArrayList<Word> sharingBoardWords, int pWordColor, String locationType) {
    this.Text = wordText;
    this.FontName = wordFontName;
    this.FontSize = wordFontSize;
    this.wordColor = pWordColor;
    this.EspacioRandomizable = new PVector(width/2, 0);
    calculateParticles(wordText);
    
    switch (locationType) {
      case "RANDOM":
        calculateRandomPosition(sharingBoardWords);
        break;
      case "FIXED":
        // TODO
        break;
    }
  }
  
  private void calculateParticles(String wordText) {
    // Fill particles ArrayList
    //// Draw word in memory
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.clear();
    pg.fill(255);
    pg.textSize(this.FontSize);
    pg.textAlign(LEFT);
    PFont font = createFont(this.FontName, this.FontSize);
    pg.textFont(font);
    pg.text(wordText, width/2, height/2);
    pg.endDraw();
    pg.loadPixels();
    ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();
    for (int i = 0; i < (width*height)-1; i+= pixelSteps) {
      coordsIndexes.add(i);
    }
    for (int i = 0; i < coordsIndexes.size (); i++) {
      int coordIndex = coordsIndexes.get(i);
      // Only continue if the pixel is not blank
      if (pg.pixels[coordIndex] != 0) {
        // Convert index to its coordinates
        int x = coordIndex % width;
        int y = coordIndex / width;
        this.ComponentParticles.add(new Particle(true, x, y, this.wordColor));
      }
    }
    int x0 = width;
    int y0 = height;
    //// Searches initial X,Y for the word.
    for (Particle p : this.ComponentParticles) {
      if (p.target.x < x0) x0 = (int)p.target.x;
      if (p.target.y < y0) y0 = (int)p.target.y;
    }
    //// Sets all X,Y from all points relative to x0,y0
    for (Particle p : this.ComponentParticles) {
      p.target.x = p.target.x - x0;
      p.target.y = p.target.y - y0;
    }
    this.Size = this.calculateSizeVector();
  }
  
  private void calculateRandomPosition(ArrayList<Word> sharingBoardWords) {
    boolean acceptedCoords = false;
    int locX;
    int locY;
    while (!acceptedCoords) {
      // choose location
      locX = PApplet.parseInt(random(buffer,width-buffer*8));
      locY = PApplet.parseInt(random(buffer,height-buffer*2));

      boolean checkWords = true;
      
      rectangle = new Rectangle(locX-10, locY-10, (int)this.Size.x+10, (int)this.Size.y+10);
      // Ensure full word is visible (inside the margin)
      if ((locX + this.Size.x) > (width-10) || locY + this.Size.y > height-10) {
        checkWords = false;
        continue;
      }
      for ( int i = 0; i < sharingBoardWords.size(); i++)
      {
        if (rectangle.intersects(((Word)sharingBoardWords.get(i)).rectangle))
        {
          checkWords = false;
          break;
        }
      }
      if (checkWords)
      {
        acceptedCoords = true;
        //rect(locX, locY, (int)this.Size.x, (int)this.Size.y);
        this.TopLeftPos = new PVector(locX, locY);
        /*for (Particle p : this.ComponentParticles) {
          p.target.x += this.TopLeftPos.x;
          p.target.y += this.TopLeftPos.y;
        }*/
        updateParticlesTarget();
      }
    }
  }
  
  public void updateParticlesTarget() {
            for (Particle p : this.ComponentParticles) {
          p.target.x += this.TopLeftPos.x;
          p.target.y += this.TopLeftPos.y;
        }
  }
  
  public void alignParticles() {
    // Align particles to show the word.
    for (Particle p : this.ComponentParticles) {
      p.move();
    }
  }
  
  public void disalignParticles(int force, float conversionFactor) {
    // Disarm the word. Kill the particles when they are not visible anymore.
    // When completely disaligned: this.IsAligned = false;
    int nParticlesToDisalign = (int) (force * conversionFactor);
    ArrayList<Particle> particlesDisaligning = new ArrayList<Particle>();
    ArrayList<Particle> particlesToDisalign = new ArrayList<Particle>();
    for (Particle p : this.ComponentParticles) {
      if (p.isDisaligning)
        particlesDisaligning.add(p);
      if (!p.isKilled)
        particlesToDisalign.add(p);
    }
    while (nParticlesToDisalign > 0 && particlesToDisalign.size() > 0) {
      int randomIndex = 0;
      if (particlesToDisalign.size() > 1)
        randomIndex = (int) random(0, particlesToDisalign.size() - 1);
      particlesDisaligning.add(particlesToDisalign.get(randomIndex));
      particlesToDisalign.remove(randomIndex);
      nParticlesToDisalign -= 1;
    }
    for (Particle p : particlesDisaligning) {
      p.disalign();
    }
  }
  
  private PVector calculateSizeVector() {
    PVector size = new PVector();
    for (Particle p : this.ComponentParticles) {
      if (size.x == 0 || size.x < p.pos.x)
        size.x = p.target.x;
      if (size.y == 0 || size.y < p.pos.y)
        size.y = p.target.y;
      p.target.x = p.target.x + this.TopLeftPos.x;
      p.target.y = p.target.y + this.TopLeftPos.y;
    }
    return size;
  }
  
  public void draw() {
    for (Particle p : this.ComponentParticles) {
      p.draw();
    }
  }
  
  public boolean allParticlesAligned() {
    boolean allAligned = true;
    for (Particle p : this.ComponentParticles) {
      if (!p.isAligned()) return false;
    }
    return allAligned;
  }
  
  public boolean isCompletelyDisaligned() {
    boolean completelyDisaligned = false;
    int disalignedParticles = 0;
    int totalParticles = this.ComponentParticles.size();
    for (Particle p : this.ComponentParticles) {
      if (p.isKilled)
        disalignedParticles += 1;
    }
    if (disalignedParticles >= totalParticles)
      completelyDisaligned = true;
    return completelyDisaligned;
  }
  //ex rectangle
  public float Largo() {
    return this.Size.x;
  }
  public float altura() {//no esta en uso
    return this.Size.x;
  }
  public void ponerEnColumna(String column) {
    this.col=column;
    if (this.col.equals("der")) { 
      TopLeftPos.x=(width/2);
    }
  }
  public String columna() {
    return col;
  }
  public void randomizar(String direccion) {
    if(direccion.equals("der")){
      this.TopLeftPos.x=this.TopLeftPos.x+(random(EspacioRandomizable.x));//x
      this.TopLeftPos.y=this.TopLeftPos.y+(random(EspacioRandomizable.y));//y
    }
    else if(direccion.equals("izq")){
      this.TopLeftPos.x=this.TopLeftPos.x-(random(EspacioRandomizable.x));//x
      this.TopLeftPos.y=this.TopLeftPos.y-(random(EspacioRandomizable.y));//y
    }
    else{
      println("Error randomizar");
    }
    this.EspacioRandomizable.set(0, 0);
  }
  public void darEspacioParaRandom(int x, int y,String direccion) {
    this.EspacioRandomizable.x=this.EspacioRandomizable.x+x;
    this.EspacioRandomizable.y=this.EspacioRandomizable.y+y;
    this.randomizar(direccion);
  }
  public void posicionarEnRow(int row) {
    this.TopLeftPos.y=(this.Size.y)*row;
  }
  
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
