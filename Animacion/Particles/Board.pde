class Board {
  PVector Size;
  ArrayList<Word> Fears;
  ArrayList<Word> Strengths;
  Word currentWord;
  Configuration Config;
  ArrayList<Row> Rows = new ArrayList<Row>();
  
  public Board(Configuration config) {
    this.Fears = new ArrayList<Word>();
    this.Strengths = new ArrayList<Word>();
    this.Config = config;
    initialize(this.config.Fears,this.Fears,this.Config);
    initialize(this.config.Strengths,this.Strengths,this.Config);
    
    switch (this.Config.LocationType) {
      case "RANDOM":
        break;
      case "FIXED":
        //alignInRows();
        break;
    }
  }
  private void initialize(ArrayList<Word> from,ArrayList<Word> to,Configuration config ){
    for (String word : from) {
      int rndm = (int)random(0, this.config.StrengthsColors.size());
      if (rndm >= this.config.StrengthsColors.size()) rndm = this.config.StrengthsColors.size() - 1;
      color wColor = color(this.config.StrengthsColors.get(rndm));
      to.add(new Word(word, this.config.FontName, this.config.FontSize, to, wColor, this.config.LocationType));
    }
  }
  
  private void getNextAlignedWord() {
    if (this.currentWord != null)
      this.Fears.remove(this.currentWord);
    this.currentWord = null;
    if (this.Fears.size() == 0) return;
    boolean aligned = false;
    while (!aligned) {
      int randomIndex = (int) random(0, this.Fears.size() - 1);
      if (!this.Fears.get(randomIndex).isCompletelyDisaligned()) {
        this.currentWord = this.Fears.get(randomIndex);
        aligned = true;
      }
    }
  }
  
  private void alignAll(ArrayList<Word> wordList) {
    for (Word current : wordList) {
      current.alignParticles();
    }
    this.drawAll(wordList);
  }
  
  // Returns true when it can continue disaligning, else false (if currentWord is null after getNextAlignedWord, there are no more available words to disalign).
  public boolean disalignWord(int force) {
    if (this.currentWord == null || this.currentWord.isCompletelyDisaligned()) this.getNextAlignedWord();
    if (this.currentWord == null) return false;
    this.currentWord.disalignParticles(force, Config.DisalignConversionFactor);
    return true;
  }
    
  public boolean wordsAligned(ArrayList<Word> wordList) {
    boolean allAligned = true;
    for (Word word : wordList) {
      if (!word.allParticlesAligned()) return false;
    }
    return allAligned;
  }
  
  public void drawAll(ArrayList<Word> wordList) {
    for (Word current : wordList) {
      current.draw();
    }
  }
  
  private void alignInRows (ArrayList<Word> wordsToAlign){//new words positioning algorithmn
    float wordHeight = 0;
    for (Word w : wordsToAlign) {
      if (w.Size.y > wordHeight) wordHeight = w.Size.y;
    }
    for (int i = 0; i < height/wordHeight; i++) {
      this.Rows.add(new Row(i));
    }
    for (int i=0; i<wordsToAlign.size(); i++) {//agrego los rect a los row
      Row rowCandidato = Rows.get(int(random((Rows.size()))));
      while (rowCandidato.cantidadDeWords() == 2) {//max 2 por row
        rowCandidato = Rows.get(int(random( (Rows.size()))));
      }
      rowCandidato.agregarPalabra(wordsToAlign.get(i));
    }
    for (Row r : Rows) {
      r.mergeColumn(wordHeight);
    } 
  }
}
