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
    for (String fear : config.Fears) {
      this.Fears.add(new Word(fear, this.Config.FontName, this.Config.FontSize, this.Fears));
    }
    for (String strength : config.Strengths) {
      this.Strengths.add(new Word(strength, this.Config.FontName, this.Config.FontSize, this.Strengths));
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
}