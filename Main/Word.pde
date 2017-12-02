import java.awt.Rectangle;

class Word {
  int pixelSteps = 1;
  public String Text;
  public PVector TopLeftPos = new PVector(0,0);
  public PVector Size = new PVector(0,0);
  public int FontSize;
  public String FontName;
  public Boolean IsAligned = true;
  private String col;//izq der
  private PVector EspacioRandomizable;
  float alignPercentage = 100;
  int buffer = 20;
  Rectangle rectangle;
  public color wordColor;
  private PFont font;
  
  public Word(String wordText, String wordFontName, int wordFontSize, ArrayList<Word> sharingBoardWords, color pWordColor, String locationType, float pAlignPercentage) {
    this.Text = wordText;
    this.FontName = wordFontName;
    this.FontSize = wordFontSize;
    this.wordColor = pWordColor;
    this.EspacioRandomizable = new PVector(width/2, 0);
    this.Size.x = textWidth(this.Text);
    this.Size.y = this.FontSize;
    this.alignPercentage = pAlignPercentage;
    this.font = createFont(wordFontName, wordFontSize);
    
    switch (locationType) {
      case "RANDOM":
        calculateRandomPosition(sharingBoardWords);
        break;
      case "FIXED":
        // TODO
        break;
    }
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
      }
    }
  }
  
  public PVector calculateSizeVector() {
    PVector size = new PVector();
    size.y = textAscent();
    size.x = textWidth(Text);
    return size;
  }
  
  public void draw() {
    boolean alignLeft = true;
    if (this.TopLeftPos.x > width / 2) alignLeft = false;
    // Update color with alpha from alingment.
    if (alignPercentage < 10) return;
    float leftTopX = TopLeftPos.x;
    if (alignLeft) {
      textAlign(LEFT);
      leftTopX = 10;
    } else {
      textAlign(RIGHT);
      leftTopX = width - 20;
    }
    textFont(this.font);
    this.wordColor = color(red(this.wordColor), green(this.wordColor), blue(this.wordColor), alignPercentage);
    fill(this.wordColor);
    //println("Word: " + Text + " - TopLeftPos: " + this.TopLeftPos);
    text(Text, leftTopX, TopLeftPos.y);
  }
  
  public void setTopLeftPos(PVector tlPos) {
    //println("Word: " + Text + " - TopLeftPos: " + this.TopLeftPos + " -> " + tlPos);
    this.TopLeftPos = tlPos;
  }
  
  public boolean isCompletelyDisaligned() {
    boolean completelyDisaligned = false;
    if (alignPercentage < 10) completelyDisaligned = true;
    return completelyDisaligned;
  }
  
  public void disalign(float force) {
    if (this.Text.startsWith("Strength")) {
      //println("Palabra: " + this.Text + " - Disaligning. AlignPercentage: " + this.alignPercentage);
      //Thread.dumpStack();
    }
    alignPercentage = alignPercentage - force;
  }
  public void align(float force) {
    if (this.Text.startsWith("Strength")) {
      //println("Palabra: " + this.Text + " - Aligning. AlignPercentage: " + this.alignPercentage);
      //Thread.dumpStack();
    }
    alignPercentage = alignPercentage + force;
    if (alignPercentage > 100) alignPercentage = 100;
  }
  
  //ex rectangle
  public float Largo() {
    return this.Size.x;
  }
  public float altura() {//no esta en uso
    return this.Size.x;
  }
  public void ponerEnColumna(String column) {
    this.col = column;
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
  public void posicionarEnRow(int row) {
    this.TopLeftPos.y=(this.Size.y)*row;
  }
  
  
}