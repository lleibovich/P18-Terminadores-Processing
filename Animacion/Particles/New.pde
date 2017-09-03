import processing.opengl.*;

color bgColor = color(255, 100);
Configuration cfg;
ArrayList<Word> fears;
ArrayList<Word> strengths;
boolean centered;

void settings() {
  fullScreen(P2D);
}

void setup() {
  background(255);
  centered = false;

  cfg = new Configuration();
  fears = new ArrayList<Word>();
  strengths = new ArrayList<Word>();
}

void draw() {
  if(frame != null && centered == false)
  {
    centered = true;
    for (String s : cfg.Fears) {
      fears.add(new Word(s, cfg.FontName, cfg.FontSize, fears));
    }
    for (String s : cfg.Strengths) {
      strengths.add(new Word(s, cfg.FontName, cfg.FontSize, strengths));
    }
  }
  // Background & motion blur
  fill(bgColor);
  noStroke();
  for (Word w : fears) {
    w.draw();
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