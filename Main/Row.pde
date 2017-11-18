class Row {
  protected ArrayList<Word> Words = new ArrayList<Word>();//serian 2 por row por ahora
  public int numeroDeRow;
  public Row(int n) {//contructor
    this.numeroDeRow=n;
  }
  public void addWord(Word r,String animation) {
    Word aux ;
    if (this.Words.size() == 0) {
      agregarRectangulo(r,"rnd",animation);
    } 
    else if (this.Words.size() == 1) {
      aux = Words.get(0);
      if (aux.columna().equals("der")) {
        agregarRectangulo(r, "izq",animation);
      } else {
        agregarRectangulo(r, "der",animation);
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
  
  private void agregarRectangulo(Word rec, String pos,String anim) {
     if(pos.equals("rnd")){
       rec.ponerEnColumna(columnaRandom());
     }
     else{
       rec.ponerEnColumna(pos);
     }
     rec.darEspacioParaRandom(0-int(rec.Largo()), 0,"der");
     rec.posicionarEnRow(this.numeroDeRow);
     this.Words.add(rec);
  }
  public void mergeColumn(float wordHeight) {
    if (this.wordAmount() == 1) {
      Word rectangulo=this.Words.get(0);
      String posFinal = "der";
      if (rectangulo.columna().equals("der")) posFinal = "izq";
      rectangulo.darEspacioParaRandom(int(wordHeight), 0, posFinal);
    }
  }
}