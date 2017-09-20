class Particle {
  boolean drawAsPoints = false;
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  public PVector target = new PVector(0, 0);

  float closeEnoughTarget = 50;
  float maxSpeed = 5.0;
  float maxForce = 0.1;
  float particleSize = 5;
  public boolean isKilled = false;
  public boolean isDisaligning = false;

  color startColor = color(0);
  color targetColor = color(0);
  float colorWeight = 0;
  float colorBlendRate = 0.025;

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
  
  Particle(boolean pDrawAsPoints, int x, int y, color particleColor) {
    this.drawAsPoints = pDrawAsPoints;
    this.target.x = x;
    this.target.y = y;
    this.pos.x = width/2;
    this.pos.y = height/2;
    this.targetColor = particleColor;
  }

  void move() {
    // Check if particle is close enough to its target to slow down
    float proximityMult = 1.0;
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

  void draw() {
    if (!this.isKilled) {
      // Draw particle
      color currentColor = lerpColor(this.startColor, this.targetColor, this.colorWeight);
      if (drawAsPoints) {
        stroke(currentColor);
        point(this.pos.x, this.pos.y);
      } else {
        noStroke();
        fill(currentColor);
        ellipse(this.pos.x, this.pos.y, this.particleSize, this.particleSize);
      }
  
      // Blend towards its target color
      if (this.colorWeight < 1.0) {
        this.colorWeight = min(this.colorWeight+this.colorBlendRate, 1.0);
      }
    }
  }

  void kill() {
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
  
  /*public boolean isDisaligning() {
    if (!this.isKilled && this.pos.x != this.target.x && this.pos.y != this.target.y)
      return true;
    else
      return false;
  }*/
  
  boolean isOutOfBoundaries() {
    if (this.pos == null) return false;
    return ((this.pos.x < 0 || this.pos.x > width) && (this.pos.y < 0 || this.pos.y > height));
  }
  
  boolean isTargetOutOfBoundaries() {
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