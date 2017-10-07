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
    for (String fear : config.Fears) {//fears loading
      int rndm = (int)random(0, this.Config.FearsColors.size());
      if (rndm >= this.Config.FearsColors.size()) rndm = this.Config.FearsColors.size() - 1;
      color wColor = color(this.Config.FearsColors.get(rndm));
      this.Fears.add(new Word(fear, this.Config.FontName, this.Config.FontSize, this.Fears, wColor, this.Config.LocationType));
    }
    for (String strength : config.Strengths) {
      int rndm = (int)random(0, this.Config.StrengthsColors.size());
      if (rndm >= this.Config.StrengthsColors.size()) rndm = this.Config.StrengthsColors.size() - 1;
      color wColor = color(this.Config.StrengthsColors.get(rndm));
      this.Strengths.add(new Word(strength, this.Config.FontName, this.Config.FontSize, this.Strengths, wColor, this.Config.LocationType));
    }
    
    switch (this.Config.LocationType) {
      case "RANDOM":
        break;
      case "FIXED":
        //alignInRows();
        break;
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