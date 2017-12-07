class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color partColor;

  Particle(PVector l, color particleColor) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    //lifespan = 255.0;
    lifespan = 50.0;
    partColor = particleColor;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(partColor, lifespan);
    fill(partColor, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}