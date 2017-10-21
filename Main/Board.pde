class Board {
  PVector Size;
  ArrayList<Word> Fears;
  ArrayList<Word> Strengths;
  Word currentWord;
  Configuration Config;
  
  public Board(Configuration config) {
    this.Fears = new ArrayList<Word>();
    this.Strengths = new ArrayList<Word>();
    this.Config = config;
    for (String fear : config.Fears) {//fears creation to be replaced with data input
      int rndm = (int)random(0, this.Config.FearsColors.size());
      if (rndm >= this.Config.FearsColors.size()) rndm = this.Config.FearsColors.size() - 1;
      color wColor = color(this.Config.FearsColors.get(rndm));
      this.Fears.add(new Word(fear, this.Config.FontName, this.Config.FontSize, this.Fears, wColor, this.Config.LocationType));
    }
    for (String strength : config.Strengths) {//same with strenghts
      int rndm = (int)random(0, this.Config.StrengthsColors.size());
      if (rndm >= this.Config.StrengthsColors.size()) rndm = this.Config.StrengthsColors.size() - 1;
      color wColor = color(this.Config.StrengthsColors.get(rndm));
      this.Strengths.add(new Word(strength, this.Config.FontName, this.Config.FontSize, this.Strengths, wColor, this.Config.LocationType));
    }
    
    switch (this.Config.LocationType) {
      case "RANDOM":
        break;
      case "FIXED":
        alignInRows(this.Fears);
        alignInRows(this.Strengths);
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
  
  private void alignAllFears() {
    for (Word fear : this.Fears) {
      fear.alignParticles();
    }
    this.drawAllFears();
  }
  
  private void alignAllStrengths() {
    for (Word strength : this.Strengths) {
      strength.alignParticles();
    }
    this.drawAllStrengths();
  }
  
  // Returns true when it can continue disaligning, else false (if currentWord is null after getNextAlignedWord, there are no more available words to disalign).
  public boolean disalignWord(int force) {
    if (this.currentWord == null || this.currentWord.isCompletelyDisaligned()) this.getNextAlignedWord();
    if (this.currentWord == null) return false;
    this.currentWord.disalignParticles(force, Config.DisalignConversionFactor);
    return true;
  }
  
  public boolean disalignWord(int force, ArrayList<MovementExtrapolated> movements) {
    boolean canContinueDisaligning = false;
    for (Word fear : this.Fears) {
      if (fear.isCompletelyDisaligned()) continue;
      fear.disalignParticles(force, movements, Config.DisalignConversionFactor);
      if (!fear.isCompletelyDisaligned()) canContinueDisaligning = true;
    }
    return canContinueDisaligning;
  }
    
  public boolean allFearsAligned() {
    boolean allAligned = true;
    for (Word w : this.Fears) {
      if (!w.allParticlesAligned()) return false;
    }
    return allAligned;
  }
  
  public boolean allStrengthsAligned() {
    boolean allAligned = true;
    for (Word w : this.Strengths) {
      if (!w.allParticlesAligned()) return false;
    }
    return allAligned;
  }
  
  public void drawAllFears() {
    for (Word fear : this.Fears) {
      fear.draw();
    }
  }
  
  public void drawAllStrengths() {
    for (Word strength : this.Strengths) {
      strength.draw();
    }
  }
  private void alignInRows (ArrayList<Word> wordsToAlign){//new words positioning algorithmn
    float wordHeight = 0;
    ArrayList<Row> rows = new ArrayList<Row>();
    for (Word w : wordsToAlign) {
      if (w.Size.y > wordHeight) wordHeight = w.Size.y;
    }
    for (int i = 0; i < int(height/wordHeight); i++) {
      rows.add(new Row(i));
    }
    
    for (Word wordToAdd : wordsToAlign) {
      Row potentialRow = rows.get(int(random((rows.size()))));
      while (potentialRow.wordAmount() == 2) {//max 2 por row
        potentialRow = rows.get(int(random( (rows.size()))));
      }
       if(this.Config.AnimationType.equals("ANIMACION2")){
         potentialRow.addWord(wordToAdd,"ANIMACION2");
       }
       else{potentialRow.addWord(wordToAdd,"ANIMACION1");}
       //potentialRow.addWord(wordToAdd);
    }
    for (Row r : rows) {
      r.mergeColumn(wordHeight);
     // r.draw();
    } 
  }
}