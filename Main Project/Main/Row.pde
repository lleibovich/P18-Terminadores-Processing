class Row {
  protected ArrayList<Word> Words = new ArrayList<Word>();//serian 2 por row por ahora
  public int numeroDeRow;
  public Row(int n){//contructor
    this.numeroDeRow=n;
  }
  public void agregarPalabra(Word r) {
    Word aux ;
    if (this.Words.size() == 0) {
      agregarRectangulo(r,"rnd");
    } 
    else if (this.Words.size() == 1) {
      aux = Words.get(0);
      if (aux.columna().equals("der")) {
        agregarRectangulo(r, "izq");
      } else {
        agregarRectangulo(r, "der");
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
  public int cantidadDeWords() {
    return this.Words.size();
  }
  
  private void agregarRectangulo(Word rec, String pos) {
     if(pos.equals("rnd")){
       rec.ponerEnColumna(columnaRandom());
     }
     else{
       rec.ponerEnColumna(pos);
     }
     rec.darEspacioParaRandom(0-int(rec.Largo()), 0,"der");
     rec.posicionarEnRow(this.numeroDeRow);
     
     rec.updateParticlesTarget();
     this.Words.add(rec);
  }
  public void mergeColumn(float wordHeight) {
    if (this.cantidadDeWords() == 1) {
      Word rectangulo=this.Words.get(0);
      String posFinal = "der";
      if (rectangulo.columna().equals("der")) posFinal = "izq";
      rectangulo.darEspacioParaRandom(int(wordHeight), 0, posFinal);
    }
  }
}