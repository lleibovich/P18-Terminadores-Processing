import java.awt.Rectangle;

class Word {
  int pixelSteps = 1;
  public String Text;
  public PVector TopLeftPos = new PVector(0,0);
  public PVector Size;
  public int FontSize;
  public String FontName;
  public ArrayList<Particle> ComponentParticles = new ArrayList<Particle>();
  public Boolean IsAligned = true;
  private String col;//izq der
  private PVector EspacioRandomizable;
  int AlignPercentage = 100;
  int buffer = 20;
  Rectangle rectangle;
  color wordColor;
  
  public Word(String wordText, String wordFontName, int wordFontSize, ArrayList<Word> sharingBoardWords, color pWordColor, String locationType) {
    this.Text = wordText;
    this.FontName = wordFontName;
    this.FontSize = wordFontSize;
    this.wordColor = pWordColor;
    this.EspacioRandomizable = new PVector(width/2, 0);
    calculateParticles(wordText);
    
    switch (locationType) {
      case "RANDOM":
        calculateRandomPosition(sharingBoardWords);
        break;
      case "FIXED":
        // TODO
        break;
    }
  }
  
  private void calculateParticles(String wordText) {
    // Fill particles ArrayList
    //// Draw word in memory
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.clear();
    pg.fill(255);
    pg.textSize(this.FontSize);
    pg.textAlign(LEFT);
    PFont font = createFont(this.FontName, this.FontSize);
    pg.textFont(font);
    pg.text(wordText, width/2, height/2);
    pg.endDraw();
    pg.loadPixels();
    ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();
    for (int i = 0; i < (width*height)-1; i+= pixelSteps) {
      coordsIndexes.add(i);
    }
    for (int i = 0; i < coordsIndexes.size (); i++) {
      int coordIndex = coordsIndexes.get(i);
      // Only continue if the pixel is not blank
      if (pg.pixels[coordIndex] != 0) {
        // Convert index to its coordinates
        int x = coordIndex % width;
        int y = coordIndex / width;
        this.ComponentParticles.add(new Particle(true, x, y, this.wordColor));
      }
    }
    int x0 = width;
    int y0 = height;
    //// Searches initial X,Y for the word.
    for (Particle p : this.ComponentParticles) {
      if (p.target.x < x0) x0 = (int)p.target.x;
      if (p.target.y < y0) y0 = (int)p.target.y;
    }
    //// Sets all X,Y from all points relative to x0,y0
    for (Particle p : this.ComponentParticles) {
      p.target.x = p.target.x - x0;
      p.target.y = p.target.y - y0;
    }
    this.Size = this.calculateSizeVector();
  }
  
  private void calculateRandomPosition(ArrayList<Word> sharingBoardWords) {
    boolean acceptedCoords = false;
    int locX;
    int locY;
    while (!acceptedCoords) {
      // choose location
      locX = int(random(buffer,width-buffer*8));
      locY = int(random(buffer,height-buffer*2));

      boolean checkWords = true;
      
      rectangle = new Rectangle(locX-10, locY-10, (int)this.Size.x+10, (int)this.Size.y+10);
      // Ensure full word is visible (inside the margin)
      if ((locX + this.Size.x) > (width-10) || locY + this.Size.y > height-10) {
        checkWords = false;
        continue;
      }
      for ( int i = 0; i < sharingBoardWords.size(); i++)
      {
        if (rectangle.intersects(((Word)sharingBoardWords.get(i)).rectangle))
        {
          checkWords = false;
          break;
        }
      }
      if (checkWords)
      {
        acceptedCoords = true;
        //rect(locX, locY, (int)this.Size.x, (int)this.Size.y);
        this.TopLeftPos = new PVector(locX, locY);
        for (Particle p : this.ComponentParticles) {
          p.target.x += this.TopLeftPos.x;
          p.target.y += this.TopLeftPos.y;
        }
      }
    }
  }
  
  public void alignParticles() {
    // Align particles to show the word.
    for (Particle p : this.ComponentParticles) {
      p.move();
    }
  }
  
  public void disalignParticles(int force, float conversionFactor) {
    // Disarm the word. Kill the particles when they are not visible anymore.
    // When completely disaligned: this.IsAligned = false;
    int nParticlesToDisalign = (int) (force * conversionFactor);
    ArrayList<Particle> particlesDisaligning = new ArrayList<Particle>();
    ArrayList<Particle> particlesToDisalign = new ArrayList<Particle>();
    for (Particle p : this.ComponentParticles) {
      if (p.isDisaligning)
        particlesDisaligning.add(p);
      if (!p.isKilled)
        particlesToDisalign.add(p);
    }
    while (nParticlesToDisalign > 0 && particlesToDisalign.size() > 0) {
      int randomIndex = 0;
      if (particlesToDisalign.size() > 1)
        randomIndex = (int) random(0, particlesToDisalign.size() - 1);
      particlesDisaligning.add(particlesToDisalign.get(randomIndex));
      particlesToDisalign.remove(randomIndex);
      nParticlesToDisalign -= 1;
    }
    for (Particle p : particlesDisaligning) {
      p.disalign();
    }
  }
  
  private PVector calculateSizeVector() {
    PVector size = new PVector();
    for (Particle p : this.ComponentParticles) {
      if (size.x == 0 || size.x < p.pos.x)
        size.x = p.target.x;
      if (size.y == 0 || size.y < p.pos.y)
        size.y = p.target.y;
      p.target.x = p.target.x + this.TopLeftPos.x;
      p.target.y = p.target.y + this.TopLeftPos.y;
    }
    return size;
  }
  
  public void draw() {
    for (Particle p : this.ComponentParticles) {
      p.draw();
    }
  }
  
  public boolean allParticlesAligned() {
    boolean allAligned = true;
    for (Particle p : this.ComponentParticles) {
      if (!p.isAligned()) return false;
    }
    return allAligned;
  }
  
  public boolean isCompletelyDisaligned() {
    boolean completelyDisaligned = false;
    int disalignedParticles = 0;
    int totalParticles = this.ComponentParticles.size();
    for (Particle p : this.ComponentParticles) {
      if (p.isKilled)
        disalignedParticles += 1;
    }
    if (disalignedParticles >= totalParticles)
      completelyDisaligned = true;
    return completelyDisaligned;
  }
  //ex rectangle
  public float Largo() {
    return this.Size.x;
  }
  public float altura() {//no esta en uso
    return this.Size.x;
  }
  public void ponerEnColumna(String column) {
    this.col=column;
    if (this.col.equals("der")) { 
      TopLeftPos.x=(width/2);
    }
  }
  public String columna() {
    return col;
  }
  public void randomizar(String direccion) {
    if(direccion.equals("der")){
      this.TopLeftPos.x=this.TopLeftPos.x+(random(EspacioRandomizable.x));//x
      this.TopLeftPos.y=this.TopLeftPos.y+(random(EspacioRandomizable.y));//y
    }
    else if(direccion.equals("izq")){
      this.TopLeftPos.x=this.TopLeftPos.x-(random(EspacioRandomizable.x));//x
      this.TopLeftPos.y=this.TopLeftPos.y-(random(EspacioRandomizable.y));//y
    }
    else{
      println("Error randomizar");
    }
    this.EspacioRandomizable.set(0, 0);
  }
  public void darEspacioParaRandom(int x, int y,String direccion) {
    this.EspacioRandomizable.x=this.EspacioRandomizable.x+x;
    this.EspacioRandomizable.y=this.EspacioRandomizable.y+y;
    this.randomizar(direccion);
  }
  public void mostrar() {
    fill(random(240), random(240), random(240));
    rect(this.TopLeftPos.x, this.TopLeftPos.y, this.Size.x, this.Size.y);
  }
  public void posicionarEnRow(int row) {
    this.TopLeftPos.y=(this.Size.y)*row;
  }
  
  
}