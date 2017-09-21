class Row {
  protected ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();//serian 2 por row por ahora
  //  protected float espacioVacioIzquierda=(width/2);//cantidad de espacio disponible para variar randomente
  // protected float espacioVacioDerecha = (width/2);//deberia ser entero pero por mantener tipos
  public int NumeroDeRow;
  public Row(int n){//contructor
    this.NumeroDeRow=n;
  }
  public int CantidadDePalabras() {
    return this.rectangles.size();
  } 
  public void AgregarPalabra(Rectangle r) {//un poco largo se debe poder mejorar
    Rectangle aux ;
    if(debug){println("AgregarPalabra ");}
    if (this.rectangles.size()==0) {
      if(debug){print("Size = 0 ");}
      AgregarRectangulo(r,"rnd");
    } else if (this.rectangles.size()==1) {
      if(debug){print("Size = 1 ");}
      aux=rectangles.get(0);
      if (aux.Columna().equals("der")) {
        if(debug){println(" Agregar a la izquierda ");}
        AgregarRectangulo(r,"izq");
      } else {//izq (ya chequeado)
        if(debug){println(" Agregar a la derecha ");}
        AgregarRectangulo(r,"der");
      }
    } else {
      println("Error AgregarPalabra");
    }
  }
  public String ColumnaRandom() {//podria estar en main para ser mas gral
    float i= random(1.99);//0 o 1(1.99 por las dudas no sea cosa que tire un 2)
    if (i>0.5) {
      return "der";
    } else {
      return "izq";
    }
  }
  public int CantidadDeRectangles() {
    //println(width/2);
    return this.rectangles.size();
  }
  public void Dibujar() {
    for (Rectangle r : rectangles) {
      r.Mostrar();
    }
  }
  public void AgregarRectangulo(Rectangle rec ,String pos){
     if(pos.equals("rnd")){
       rec.PonerEnColumna(ColumnaRandom());
     }
     else{
       rec.PonerEnColumna(pos);
     }
     rec.DarEspacioParaRandom(0-int(rec.Largo()), 0);
     rec.PosicionarEnRow(this.NumeroDeRow);
     this.rectangles.add(rec);
  }
}