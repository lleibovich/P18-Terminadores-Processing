ArrayList<Particle> particles = new ArrayList<Particle>();
int pixelSteps = 6; // Amount of pixels to skip
boolean drawAsPoints = false;
ArrayList<String> words = new ArrayList<String>();
int wordIndex = 0;
color bgColor = color(255, 100);
String fontName = "Arial Bold";

 // Picks a random position from a point's radius
PVector generateRandomPos(int x, int y, float mag) {
  PVector randomDir = new PVector(random(0, width), random(0, height));
  
  PVector pos = new PVector(x, y);
  pos.sub(randomDir);
  pos.normalize();
  pos.mult(mag);
  pos.add(x, y);
  
  return pos;
}

// Makes all particles draw the next word
void nextWord(String word) {
  // Draw word in memory
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.fill(0);
  pg.textSize(100);
  pg.textAlign(CENTER);
  PFont font = createFont(fontName, 100);
  pg.textFont(font);
  pg.text(word, width/2, height/2);
  pg.endDraw();
  pg.loadPixels();

  // Next color for all pixels to change to
  color newColor = color(random(0.0, 255.0), random(0.0, 255.0), random(0.0, 255.0));

  int particleCount = particles.size();
  int particleIndex = 0;

  // Collect coordinates as indexes into an array
  // This is so we can randomly pick them to get a more fluid motion
  ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();
  for (int i = 0; i < (width*height)-1; i+= pixelSteps) {
    coordsIndexes.add(i);
  }

  for (int i = 0; i < coordsIndexes.size (); i++) {
    // Pick a random coordinate
    int randomIndex = (int)random(0, coordsIndexes.size());
    int coordIndex = coordsIndexes.get(randomIndex);
    coordsIndexes.remove(randomIndex);
    
    // Only continue if the pixel is not blank
    if (pg.pixels[coordIndex] != 0) {
      // Convert index to its coordinates
      int x = coordIndex % width;
      int y = coordIndex / width;

      Particle newParticle;

      if (particleIndex < particleCount) {
        // Use a particle that's already on the screen 
        newParticle = particles.get(particleIndex);
        newParticle.isKilled = false;
        particleIndex += 1;
      } else {
        // Create a new particle
        newParticle = new Particle(drawAsPoints);
        
        PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
        newParticle.pos.x = randomPos.x;
        newParticle.pos.y = randomPos.y;
        
        newParticle.maxSpeed = random(2.0, 5.0);//particle speed
        newParticle.maxForce = newParticle.maxSpeed*0.025;
        newParticle.particleSize = random(3, 6);
        newParticle.colorBlendRate = random(0.0025, 0.03);
        
        particles.add(newParticle);
      }
      
      // Blend it from its current color
      newParticle.startColor = lerpColor(newParticle.startColor, newParticle.targetColor, newParticle.colorWeight);
      newParticle.targetColor = newColor;
      newParticle.colorWeight = 0;
      
      // Assign the particle's new target to seek
      newParticle.target.x = x;
      newParticle.target.y = y;
    }
  }

  // Kill off any left over particles
  if (particleIndex < particleCount) {
    for (int i = particleIndex; i < particleCount; i++) {
      Particle particle = particles.get(i);
      particle.kill();
    }
  }
}
import processing.opengl.*;
void settings() {
  //size(800, 600, OPENGL);
  //size(800, 600, P2D);
  fullScreen(P2D);
}

Configuration cfg;
ArrayList<Word> fears;

boolean centered;
void setup() {
  background(255);
  centered = false;
  words.add("JAVA");
  words.add("Python <3");
  words.add("C++");
  words.add("Bye :-)");
  words.add("");

  //nextWord(words.get(wordIndex));
  cfg = new Configuration();
  fears = new ArrayList<Word>();
  /*for (String s : cfg.Fears) {
    println(s);
    fears.add(new Word(s, cfg.FontName, cfg.FontSize, fears));
  }*/
  //println("Width: " + width + "; Height: " + height);
}

void draw() {
  if(frame != null && centered == false)
  {
    //frame.setLocation(displayWidth/2-width/2,displayHeight/2-height/2);
    centered = true;
    for (String s : cfg.Fears) {
      println(s);
      fears.add(new Word(s, cfg.FontName, cfg.FontSize, fears));
    }
  }
  // Background & motion blur
  fill(bgColor);
  noStroke();
  for (Word w : fears) {
    w.draw();
  }
  /*rect(0, 0, width*2, height*2);

  for (int x = particles.size ()-1; x > -1; x--) {
    // Simulate and draw pixels
    Particle particle = particles.get(x);
    particle.move();
    particle.draw();

    // Remove any dead pixels out of bounds
    if (particle.isKilled) {
      if (particle.pos.x < 0 || particle.pos.x > width || particle.pos.y < 0 || particle.pos.y > height) {
        particles.remove(particle);
      }
    }
  }

  // Display control tips
  fill(255-red(bgColor));
  textSize(9);
  String tipText = "Left-click for a new word.";
  tipText += "\nDrag right-click over particles to interact with them.";
  tipText += "\nPress any key to toggle draw styles.";
  text(tipText, 10, height-40);*/
  
}


// Show next word
void mousePressed() {
  if (mouseButton == LEFT) {
    wordIndex += 1;
    if (wordIndex > words.size()-1) { 
      wordIndex = 0;
    }
    nextWord(words.get(wordIndex));
  }
}


// Kill pixels that are in range
void mouseDragged() {
  if (mouseButton == RIGHT) {
    for (Particle particle : particles) {
      if (dist(particle.pos.x, particle.pos.y, mouseX, mouseY) < 50) {
        particle.kill();
      }
    }
  }
}


// Toggle draw modes
void keyPressed() {
  drawAsPoints = (! drawAsPoints);
  if (drawAsPoints) {
    background(0);
    bgColor = color(0, 40);
  } else {
    background(255);
    bgColor = color(255, 100);
  }
}