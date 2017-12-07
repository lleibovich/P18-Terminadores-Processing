import processing.opengl.*;
import processing.video.*;
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
ArrayList <SkeletonData> bodies;

Kinect kinect;
KinectMov kinectmov;
Capture video;
Cameras cameras;

color bgColor = color(255, 100, 50);
Configuration cfg;
ArrayList<Word> fears;
ArrayList<Word> strengths;
boolean centered;
Board board;
boolean creatingBoard;
boolean aligningFears;
boolean disaligningFears;
boolean aligningStrengths;

void settings() {
  //fullScreen(P2D);
  size(1280, 720);
}

void setup() {
  colorMode(RGB, 255, 255, 255, 100);
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
  if (this.cfg.SensorType.equals("KINECT")) {
    kinect = new Kinect(this);
    kinectmov = new KinectMov();
    bodies = new ArrayList<SkeletonData>();
  } else if (this.cfg.SensorType.equals("CAMERA") || this.cfg.SensorType.equals("CAMERAMOVEMENT")) {
    video = new Capture(this, 640, 480, "FaceCam 1000X");
    video.start();
    video.loadPixels();
    cameras = new Cameras(this.cfg);
  }
  total();
  board = new Board(cfg);
}

int msPreviousDisalign = 0;
ArrayList<Particle> ParticlesAlive = new ArrayList<Particle>();

void draw() {
  // Background & motion blur
  noStroke();

  background(this.cfg.BackgroundColor);
  PImage reverse = new PImage( video.width, video.height );
  if (this.cfg.Mirrored) {
    for(int i=0; i < video.width; i++ ){
      for(int j=0; j < video.height; j++){
        reverse.set( video.width - 1 - i, j, video.get(i, j) );
      }   
    }
  } else reverse = video;
  image(reverse, 0, 0, width, height);
  
  fill(0);
  stroke(126);
  line((width/3), 0, (width/3), height);
  line(2*(width/3), 0, 2*(width/3), height);
  line(0, (height/4), width, (height/4));
  line(0, 2*(height/4), width, 2*(height/4));
  line(0, 3*(height/4), width, 3*(height/4));
  //line(0, 4*(height/4)-5, width, (height/4)+5);
  
  total();
  int force = 0;
  if ((millis() - msPreviousDisalign) > this.cfg.DisalignIntervalMs) {
    msPreviousDisalign = millis();
    force = getForce();
    boolean[][] movements = getMovements();
    for (int i = 0; i < this.cfg.ColsQuantity; i++) {
      for (int j = 0; j < this.cfg.RowsQuantity; j++) {
        if (movements[i][j] == true) {
          Zone zone = this.board.zoneMatrix[i][j];
          if (!(zone.fears == null || zone.fears.size() == 0 || zone.fears.get(0).isCompletelyDisaligned())) {
            PVector wordTopLeft = zone.fears.get(0).TopLeftPos;
            PVector wordSize = zone.fears.get(0).calculateSizeVector();
            boolean alignLeft = true;
            if (wordTopLeft.x > width / 2) alignLeft = false;
            float leftTopX = wordTopLeft.x;
            float xPos = 0;
            if (alignLeft) {
              textAlign(LEFT);
              leftTopX = 10;
              xPos = leftTopX + (wordSize.x/2);
            } else {
              textAlign(RIGHT);
              leftTopX = width - 20;
              xPos = leftTopX - (wordSize.x/2);
            }
            
            float yPos = wordTopLeft.y - (wordSize.y/2);
            PVector position = new PVector(xPos, yPos);
            color particleColor = zone.fears.get(0).wordColor;
            for (int k = 0; k < (int) force * this.cfg.DisalignConversionFactor; k++) {
              ParticlesAlive.add(new Particle(position, particleColor));
            }
          }
          for (Word fear : zone.fears) {
            fear.disalign(force * this.cfg.DisalignConversionFactor);
          }
          for (Word strength : zone.strengths) {
            strength.align(force * this.cfg.DisalignConversionFactor);
          }
        }
      }
    }
  }
  board.drawAllFears();
  board.drawAllStrengths();
  for (int i = ParticlesAlive.size()-1; i >= 0; i--) {
    Particle p = ParticlesAlive.get(i);
    p.run();
    if (p.isDead()) {
      ParticlesAlive.remove(i);
    }
  }
}

int getForce() {
  int force = 0;
  force = cameras.cons;
  return force;
}

boolean[][] getMovements() {
  return cameras.movementMap;
}

void total() {
  cameras.clvar();
  cameras.cameras();
  //thread("total");
}