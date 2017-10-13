import processing.opengl.*;
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
ArrayList <SkeletonData> bodies;

Kinect kinect;
KinectMov kinectmov;

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
  fullScreen(P2D);
  //size(1024,768,P2D);
}

void setup() {
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
 println(this.cfg.SensorType);
  if (this.cfg.SensorType.equals("KINECT")) {
    println("inicializar kinect");
    kinect = new Kinect(this);
    kinectmov = new KinectMov();
    bodies = new ArrayList<SkeletonData>();
    total();
  }
}

  int msPreviousDisalign = 0;


void draw() {
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
  
  if (this.cfg.SensorType.equals("KINECT")) {
    //println("print kn");
    textSize(72);
    text(kinectmov.cons,width/2,height/2);
  }
}

int getForce() {
  int force = 0;
  switch(this.cfg.SensorType) {
    case "RANDOM":
      force = (int)random(0, 6);
      break;
    case "KINECT":
      force = kinectmov.cons;
      print("Force ");
      println(force);
      break;
    case "CAMERA":
      // TODO
      break;
  }
  return force;
}

void total() {
  kinectmov.total();
  thread("total"); 
}

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
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

void moveEvent(SkeletonData _b, SkeletonData _a)
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