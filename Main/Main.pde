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
  //fullScreen();
  size(800, 600, P2D);
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
  //println(this.cfg.SensorType);
  if (this.cfg.SensorType.equals("KINECT")) {
    println("inicializar kinect");
    kinect = new Kinect(this);
    kinectmov = new KinectMov();
    bodies = new ArrayList<SkeletonData>();
  } else if (this.cfg.SensorType.equals("CAMERA") || this.cfg.SensorType.equals("CAMERAMOVEMENT")) {
    video = new Capture(this, 640, 480);
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
  total();
  int force = 0;
  if ((millis() - msPreviousDisalign) > this.cfg.DisalignIntervalMs) {
    msPreviousDisalign = millis();
    force = getForce();
    boolean[][] movements = getMovements();
    for (int i = 0; i < this.cfg.ColsQuantity; i++) {
      for (int j = 0; j < this.cfg.RowsQuantity; j++) {
        if (movements[i][j] == true) {
          //println("Disalign/align: " + i + " " + j);
          Zone zone = this.board.zoneMatrix[i][j];
          //println("Zone " + i + "," + j + " fears: " + zone.fears);
          //println("Zone " + i + "," + j + " strengths: " + zone.strengths);
          for (Word fear : zone.fears) {
            fear.disalign(force * this.cfg.DisalignConversionFactor);
          }
          for (Word strength : zone.strengths) {
            strength.align(force * this.cfg.DisalignConversionFactor);
          }
          if (!(zone.fears == null || zone.fears.size() == 0 || zone.fears.get(0).isCompletelyDisaligned())) {
            PVector wordTopLeft = zone.fears.get(0).TopLeftPos;
            PVector wordSize = zone.fears.get(0).calculateSizeVector();
            float xPos = wordTopLeft.x + (wordSize.x/2);
            float yPos = wordTopLeft.y - (wordSize.y/2);
            PVector position = new PVector(xPos, yPos);
            for (int k = 0; k < 10/*(int) force * this.cfg.DisalignConversionFactor*/; k++) {
              ParticlesAlive.add(new Particle(position));
            }
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