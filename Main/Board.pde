class Board {
  PVector Size;
  ArrayList<Word> Fears;
  ArrayList<Word> Strengths;
  Word currentWord;
  Configuration Config;
  public Zone[][]zoneMatrix;
  public Board(Configuration config) {
    this.Fears = new ArrayList<Word>();
    this.Strengths = new ArrayList<Word>();
    this.Config = config;
    for (String fear : config.Fears) {//fears creation to be replaced with data input
      int rndm = (int)random(0, this.Config.FearsColors.size());
      if (rndm >= this.Config.FearsColors.size()) rndm = this.Config.FearsColors.size() - 1;
      color wColor = color(this.Config.FearsColors.get(rndm));
      this.Fears.add(new Word(fear, this.Config.FontName, this.Config.FontSize, this.Fears, wColor, this.Config.LocationType, 100));
    }
    for (String strength : config.Strengths) {//same with strenghts
      int rndm = (int)random(0, this.Config.StrengthsColors.size());
      if (rndm >= this.Config.StrengthsColors.size()) rndm = this.Config.StrengthsColors.size() - 1;
      color wColor = color(this.Config.StrengthsColors.get(rndm));
      this.Strengths.add(new Word(strength, this.Config.FontName, this.Config.FontSize, this.Strengths, wColor, this.Config.LocationType, 0));
    }

    switch (this.Config.LocationType) {
    case "RANDOM":
      break;
    case "FIXED":
      alignInRows();
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
    this.drawAllFears();
  }

  private void alignAllStrengths() {
    this.drawAllStrengths();
  }

  // Returns true when it can continue disaligning, else false (if currentWord is null after getNextAlignedWord, there are no more available words to disalign).
  public boolean disalignWord(int force) {
    if (this.currentWord == null || this.currentWord.isCompletelyDisaligned()) this.getNextAlignedWord();
    if (this.currentWord == null) return false;
    this.currentWord.disalign(force);
    return true;
  }

  public boolean disalignWord(int force, ArrayList<MovementExtrapolated> movements) {
    boolean canContinueDisaligning = false;
    for (Word fear : this.Fears) {
      if (fear.isCompletelyDisaligned()) continue;
      ArrayList<MovementExtrapolated> movementsToWord = new ArrayList<MovementExtrapolated>();
      boolean movementWord = false;
      for (MovementExtrapolated movement : movements) {
        PVector fearStart = new PVector(fear.TopLeftPos.x, fear.TopLeftPos.y);
        PVector fearEnd = new PVector(fear.TopLeftPos.x + fear.Size.x, fear.TopLeftPos.y + fear.Size.y);
        boolean movementX = false;
        boolean movementY = false;

        if (
          (movement.from.x >= fearStart.x && movement.from.x <= fearEnd.x)
          ||
          (movement.to.x >= fearStart.x && movement.to.x <= fearEnd.x)
          ) movementX = true;

        if (
          (movement.from.y >= fearStart.y && movement.from.y <= fearEnd.y)
          ||
          (movement.to.y >= fearStart.y && movement.to.y <= fearEnd.y)
          ) movementY = true;

        if (movementX && movementY) {
          movementWord = true;
          break;
        }
      }
      //fear.disalignParticles(force, movementsToWord, Config.DisalignConversionFactor);
      force = 1000;
      if (!movementWord) force = 0;
      else println("Word: " + fear.Text + " - Move: " + movementWord);
      fear.disalign(force);
      if (!fear.isCompletelyDisaligned()) canContinueDisaligning = true;
    }
    return canContinueDisaligning;
  }

  public boolean allFearsAligned() {
    boolean allAligned = true;
    for (Word w : this.Fears) {
    }
    return allAligned;
  }

  public boolean allStrengthsAligned() {
    boolean allAligned = true;
    for (Word w : this.Strengths) {
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
  private void alignInRows () {//new words positioning algorithmn

    int rowAmount=Config.RowsQuantity;
    int columnAmount=Config.ColsQuantity;
    zoneMatrix= new Zone[columnAmount][rowAmount];
    initZones(zoneMatrix, rowAmount, columnAmount);
    addWordsToZones(zoneMatrix, rowAmount, columnAmount);
    initialDrawAll(zoneMatrix, rowAmount, columnAmount);
  }

  private void initZones(Zone[][] zoneMatrix, int rowAmount, int columnAmount) {
    for (int c=0; c<columnAmount; c++) {
      for (int f=0; f<rowAmount; f++) {
        zoneMatrix[c][f]=new Zone((int(width/columnAmount))*c,(int(height/rowAmount))*f, this.Config);
      }
    }
  }

  private void addWordsToZones(Zone[][] zoneMatrix, int rowAmount, int columnAmount) {
    int i=0;
    while(i<Fears.size()) {
      for (int c=0; c<columnAmount; c++) {
        if (c==1) {//harcoded ver changear this
        } else {
          for (int f=0; f<rowAmount; f++) {
            if(i==Fears.size())break;
            zoneMatrix[c][f].addFear(Fears.get(i));
            zoneMatrix[c][f].addStrength(Strengths.get(i));
            i++;
          }
        }
        if(i==Fears.size())break;
      }
      //foreach draw
    }
  }

  private void initialDrawAll(Zone[][]zoneMatrix, int rowAmount, int columnAmount) {
    for (int c=0; c<columnAmount; c++) {
      for (int f=0; f<rowAmount; f++) {
        zoneMatrix[c][f].firstDraw();
      }
    }
  }
}