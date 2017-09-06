class Board {
  PVector Size;
  ArrayList<Word> Fears;
  ArrayList<Word> Strengths;
  Word CurrentWord;
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
    // TO-DO: Set this.CurrentWord to the first disaligned Fear Word (random).
  }
  
  private void alignAllFears() {
    for (Word fear : this.Fears) {
      fear.alignParticles();
    }
    for (Word fear : this.Fears) {
      fear.draw();
    }
  }
  
  private void alignAllStrengths() {
    for (Word strength : this.Strengths) {
      strength.alignParticles();
    }
  }
  
  private void disalignWord() {
    if (!CurrentWord.IsAligned) this.getNextAlignedWord();
    CurrentWord.disalignParticles(this.getDisalignForce(), Config.DisalignConversionFactor);
  }
  
  private int getDisalignForce() {
    int force = 0;
    // TO-DO
    return force;
  }
}