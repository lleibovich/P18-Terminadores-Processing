import java.awt.Rectangle;

class Word {
  
  /*
    La ubicación de las palabras se va a hacer random.
  */
  int pixelSteps = 1;
  public String Text;
  public PVector TopLeftPos = new PVector(0,0);
  public PVector Size;
  public int FontSize;
  public String FontName;
  public ArrayList<Particle> ComponentParticles = new ArrayList<Particle>();
  public Boolean IsAligned = true;
  int AlignPercentage = 100;
  int buffer = 20;
  boolean acceptedCoords = false;
  Rectangle rectangle;
  int locX;
  int locY;
  
  public Word(String wordText, String wordFontName, int wordFontSize, ArrayList<Word> sharingBoardWords) {
    this.Text = wordText;
    this.FontName = wordFontName;
    this.FontSize = wordFontSize;
    
    // Fill particles ArrayList
    //// Draw word in memory
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.clear();
    pg.fill(255);
    pg.textSize(this.FontSize);
    pg.textAlign(LEFT);
    PFont font = createFont(fontName, this.FontSize);
    pg.textFont(font);
    pg.text(wordText, width/2, height/2);
    //pg.text(wordText, width/8, height/8);
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
        //println("Adding particle");
        this.ComponentParticles.add(new Particle(true, x, y));
      }
    }
    int x0 = width;
    int y0 = height;
    //// Searches initial X,Y for the word.
    for (Particle p : this.ComponentParticles) {
      if (p.pos.x < x0) x0 = (int)p.pos.x;
      if (p.pos.y < y0) y0 = (int)p.pos.y;
    }
    //// Sets all X,Y from all points relative to x0,y0
    for (Particle p : this.ComponentParticles) {
      p.pos.x = p.pos.x - x0;
      p.pos.y = p.pos.y - y0;
    }
    
    this.Size = this.calculateSizeVector();
    println(this.Size);
    
    
    while (!acceptedCoords) {
      // choose location
      locX = int(random(buffer,width-buffer*8));
      locY = int(random(buffer,height-buffer*2));

      boolean checkWords = true;
      //println("Proposed [" + locX + ";" + locY + "] - Rect [" + locX + ";" + locY + ";" + (this.Size.x + locX) + ";" + (this.Size.y + locY) + "]");

      rectangle = new Rectangle(locX, locY, (int)this.Size.x, (int)this.Size.y);
      // Ensure full word is visible (inside the margin)
      if ((locX + this.Size.x) > (width-10) || locY + this.Size.y > height-10) {
        //println("Out of bounds");
        checkWords = false;
        continue;
      }
      for ( int i = 0; i < sharingBoardWords.size(); i++)
      {
        if (rectangle.intersects(((Word)sharingBoardWords.get(i)).rectangle))
        {
          //println("Intersects");
          checkWords = false;
          break;
        }
      }

      if (checkWords)
      {
        acceptedCoords = true;
        rect(locX, locY, (int)this.Size.x, (int)this.Size.y);
        this.TopLeftPos = new PVector(locX, locY);
        for (Particle p : this.ComponentParticles) {
          p.pos.x += this.TopLeftPos.x;
          p.pos.y += this.TopLeftPos.y;
        }
      }
    }
  }
  
  public void alignParticles() {
    // TO-DO: Align particles to show the word.
  }
  
  public void disalignParticles(int force, float conversionFactor) {
    // TO-DO: Disarm the word. Kill the particles when they are not visible anymore (probably should be inside Particle).
    // When completely disaligned: this.IsAligned = false;
  }
  
  private PVector calculateSizeVector() {
    PVector size = new PVector();
    for (Particle p : this.ComponentParticles) {
      if (size.x == 0 || size.x < p.pos.x)
        size.x = p.pos.x;
      if (size.y == 0 || size.y < p.pos.y)
        size.y = p.pos.y;
      p.pos.x = p.pos.x + this.TopLeftPos.x;
      p.pos.y = p.pos.y + this.TopLeftPos.y;
    }
    return size;
  }
  
  public void draw() {
    for (Particle p : this.ComponentParticles) {
      p.draw();
    }
  }
}