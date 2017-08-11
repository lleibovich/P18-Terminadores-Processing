class Board {
  PVector Size;
  ArrayList<Word> Fears;
  ArrayList<Word> Strengths;
  Word CurrentWord;
  Configuration Config;
  
  public Board(Configuration config) {
    for (String fear : config.Fears) {
      this.Fears.add(new Word(fear, config.FontName, config.FontSize));
    }
    for (String strength : config.Strengths) {
      this.Fears.add(new Word(strength, config.FontName, config.FontSize));
    }
    this.Config = config;
  }
  
  private void locateFears() {
    // TO-DO: Specify location for each Fear Word.
  }
  
  private void locateStrengths() {
    // TO-DO: Specify location for each Strength Word.
  }
  
  private void getNextAlignedWord() {
    // TO-DO: Set this.CurrentWord to the first disaligned Fear Word (random).
  }
  
  private void alignAllFears() {
    for (Word fear : this.Fears) {
      fear.alignParticles();
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