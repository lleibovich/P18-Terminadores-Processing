
class Zone{
	//PGraphics figura = new PGraphics();
  PGraphics pg;
	ArrayList<Word> fears= new ArrayList<Word>();//por ahora 1 solo
  ArrayList<Word> strenghts= new ArrayList<Word>();
  
	public PVector Size;
	public PVector TopLeftPos;
	public Zone(int pWidth,int pHeight ){
    pg = createGraphics(pWidth, pHeight);
    TopLeftPos=new PVector();
    TopLeftPos.x=pWidth;
    TopLeftPos.y=pHeight;
	}
	public void addFears(ArrayList<Word> words ){
    this.fears.addAll(words);
	} 
  public void addFear(Word word ){
    this.fears.add(word);
  }
  public void addStrenghts(ArrayList<Word> words ){
    this.fears.addAll(words);
  } 
  public void addStrenght(Word word){
    this.fears.add(word);
  }
	public void desarmar (double fuerza){
    //ToDo
	}
  public void firstDraw () {
    
    //pg.beginDraw();
    //pg.endDraw();
  }
}