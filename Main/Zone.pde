
class Zone{
	//PGraphics figura = new PGraphics();
  PGraphics pg;
	ArrayList<Word> fears= new ArrayList<Word>();//por ahora 1 solo
  ArrayList<Word> strengths= new ArrayList<Word>();
  
	public PVector Size=new PVector();
	public PVector TopLeftPos=new PVector();

	public Zone(int pWidth,int pHeight ){
    //pg = createGraphics(pWidth, pHeight);
    TopLeftPos.x=pWidth;
    TopLeftPos.y=pHeight;
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
    for (Word w : this.fears) {
      w.setTopLeftPos(this.TopLeftPos);
    }
    for (Word w : this.strengths) {
      w.setTopLeftPos(this.TopLeftPos);
    }
    //pg.beginDraw();
    //pg.endDraw();
  }
}