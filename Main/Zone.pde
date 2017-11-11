
class Zone{
	//PGraphics figura = new PGraphics();
  PGraphics pg;
	ArrayList<Word> fears= new ArrayList<Word>();//por ahora 1 solo
  ArrayList<Word> strengths= new ArrayList<Word>();
  Configuration config;
  
	public PVector Size=new PVector();
	public PVector TopLeftPos=new PVector();

	public Zone(int pWidth,int pHeight, Configuration cfg ){
    //pg = createGraphics(pWidth, pHeight);
    TopLeftPos.x=pWidth;
    TopLeftPos.y=pHeight;
    this.config = cfg;
	}
	public void addFears(ArrayList<Word> words ){
    this.fears.addAll(words);
	} 
  public void addFear(Word word ){
    this.fears.add(word);
  }
  public void addstrengths(ArrayList<Word> words ){
    this.fears.addAll(words);
  } 
  public void addStrength(Word word){
    this.fears.add(word);
  }
	public void desarmar (double fuerza){
    //ToDo
	}
  public void firstDraw () {
    println(this.fears);
    PVector lfPos = this.TopLeftPos.copy();
    lfPos.y = lfPos.y + (height / this.config.RowsQuantity) / 2;
    for (Word w : this.fears) {
      w.setTopLeftPos(lfPos);
    }
    for (Word w : this.strengths) {
      w.setTopLeftPos(lfPos);
    }
    //pg.beginDraw();
    //pg.endDraw();
  }
}