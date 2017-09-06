import processing.opengl.*;

color bgColor = color(255, 100, 50);
Configuration cfg;
ArrayList<Word> fears;
ArrayList<Word> strengths;
boolean centered;

void settings() {
  fullScreen(P2D);
}

void setup() {
  background(bgColor);
  
  centered = false;

  cfg = new Configuration();
  fears = new ArrayList<Word>();
  strengths = new ArrayList<Word>();
}

void draw() {
  // Background & motion blur
  background(bgColor);
  fill(bgColor);
  noStroke();
  if(frame != null && centered == false)
  {
    centered = true;
    for (String s : cfg.Fears) {
      fears.add(new Word(s, cfg.FontName, cfg.FontSize, fears));
    }
    for (String s : cfg.Strengths) {
      strengths.add(new Word(s, cfg.FontName, cfg.FontSize, strengths));
    }
    for (Word w : fears) {
      w.draw();
    }
  } else {
    for (Word w : fears) {
      w.alignParticles();
    }
    for (Word w : fears) {
      w.draw();
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