import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import java.awt.Rectangle; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Particles extends PApplet {

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
    for (String fear : config.Fears) {
      int rndm = (int)random(0, this.Config.FearsColors.size());
      if (rndm >= this.Config.FearsColors.size()) rndm = this.Config.FearsColors.size() - 1;
      int wColor = color(this.Config.FearsColors.get(rndm));
      this.Fears.add(new Word(fear, this.Config.FontName, this.Config.FontSize, this.Fears, wColor, this.Config.LocationType));
    }
    for (String strength : config.Strengths) {
      int rndm = (int)random(0, this.Config.StrengthsColors.size());
      if (rndm >= this.Config.FearsColors.size()) rndm = this.Config.StrengthsColors.size() - 1;
      int wColor = color(this.Config.FearsColors.get(rndm));
      this.Strengths.add(new Word(strength, this.Config.FontName, this.Config.FontSize, this.Strengths, wColor, this.Config.LocationType));
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
      aligningStrengths = false;
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
      // TODO
      break;
    case "CAMERA":
      // TODO
      break;
  }
  return force;
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
  int AlignPercentage = 100;
  int buffer = 20;
  Rectangle rectangle;
  int wordColor;
  
  public Word(String wordText, String wordFontName, int wordFontSize, ArrayList<Word> sharingBoardWords, int pWordColor, String locationType) {
    this.Text = wordText;
    this.FontName = wordFontName;
    this.FontSize = wordFontSize;
    this.wordColor = pWordColor;
    
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
        for (Particle p : this.ComponentParticles) {
          p.target.x += this.TopLeftPos.x;
          p.target.y += this.TopLeftPos.y;
        }
      }
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
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Particles" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
