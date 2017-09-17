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
}

  int msPreviousDisalign = 0;


void draw() {
  // Background & motion blur
  //background(bgColor);
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
      println("All fears aligned"); // DEBUG: Know when all fears have been aligned.
      disaligningFears = true;
    }
  }
  
  if (disaligningFears) {
    background(bgColor);
    int force = 0;
    if ((millis() - msPreviousDisalign) > this.cfg.DisalignIntervalMs) {
      msPreviousDisalign = millis();
      force = (int)random(0, 6); // TODO: Get from sensor
    }
    if (!board.disalignWord(force)) {
      disaligningFears = false;
      aligningStrengths = true;
      println("All fears disaligned");
    }
    board.drawAllFears();
  }
  
  if (aligningStrengths) {
    background(bgColor);
    board.alignAllStrengths();
    if (board.allStrengthsAligned()) {
      aligningStrengths = false;
      println("All strengths aligned"); // DEBUG: Know when all fears have been aligned.
    }
  }
  
}

// Show next word
void mousePressed() {
  if (mouseButton == LEFT) {
    println("Mouse pressed");
  }
}

// Kill pixels that are in range
void mouseDragged() {
  if (mouseButton == RIGHT) {
    println("Mouse dragged");
  }
}

// Toggle draw modes
void keyPressed() {
  println("keyPressed");
}