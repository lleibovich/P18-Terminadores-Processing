class Row {
  protected ArrayList<Word> Words = new ArrayList<Word>();//serian 2 por row por ahora
  public int numeroDeRow;
  public Row(int n){//contructor
    this.numeroDeRow=n;
  }
  public void addWord(Word r,String animation) {
    Word aux ;
    if (this.Words.size() == 0) {
      asignSpace(r,"rnd",animation);
    } 
    else if (this.Words.size() == 1) {
      aux = Words.get(0);
      if (aux.columna().equals("der")) {
        asignSpace(r, "izq",animation);
      } else {
        asignSpace(r, "der",animation);
      }
    } else {
      println("Error AgregarPalabra");
    }
  }
  public String columnaRandom() {
    float i= random(1.99);//0 o 1(1.99 por las dudas no sea cosa que tire un 2)
    if (i > 0.5) {
      return "der";
    } else {
      return "izq";
    }
  }
  public int wordAmount() {
    return this.Words.size();
  }
  
  private void asignSpace(Word rec, String pos,String anim) {
     if(pos.equals("rnd")){
       rec.ponerEnColumna(columnaRandom());
     }
     else{
       rec.ponerEnColumna(pos);
     }
     rec.darEspacioParaRandom(0-int(rec.lenght()), 0,"der");
     rec.posicionarEnRow(this.numeroDeRow);
     
     if(anim.equals("ANIMACION2")){
       rec.updateParticlesTargetNoAnim();
     }
     else{rec.updateParticlesTarget();};
     this.Words.add(rec);
  }
  public void mergeColumn(int percentToleaveBetweenWords) {
    if (this.wordAmount() == 1) {
      Word word=this.Words.get(0);
      String posFinal = "der";
      if (word.columna().equals("der")) posFinal = "izq";
      word.darEspacioParaRandom(int(word.Size.x), 0, posFinal);
      if(word.TopLeftPos.x<percentToleaveBetweenWords/100){
        word.darEspacioParaRandom(percentToleaveBetweenWords/100, 0, "der");
      }
      else if(word.TopLeftPos.x>width-(percentToleaveBetweenWords/100)){
        word.darEspacioParaRandom(percentToleaveBetweenWords/100, 0, "izq");
      }
    }
  }
}