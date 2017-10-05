import processing.opengl.*;

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
    board.alignAll(board.Fears);
    if (board.wordsAligned(board.Fears)) {
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
    board.drawAll(board.Fears);
  }
  
  if (aligningStrengths) {
    background(bgColor);
    board.alignAll(board.Strengths);
    if (board.wordsAligned(board.Strengths)) {
      aligningStrengths = false;
    }
  }
  
}

int getForce() {
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