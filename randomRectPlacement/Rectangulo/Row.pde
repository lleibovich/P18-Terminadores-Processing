class Row {
  protected ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();//serian 2 por row por ahora
  public int numeroDeRow;
  public Row(int n){//contructor
    this.numeroDeRow=n;
  }
  public void agregarPalabra(Rectangle r) {//un poco largo se debe poder mejorar
    Rectangle aux ;
    if(debug){println("AgregarPalabra ");}
    if (this.rectangles.size()==0) {
      if(debug){print("Size = 0 ");}
      agregarRectangulo(r,"rnd");
    } 
    else if (this.rectangles.size()==1) {
      if(debug){print("Size = 1 ");}
      aux=rectangles.get(0);
      if (aux.columna().equals("der")) {
        if(debug){println(" Agregar a la izquierda ");}
        agregarRectangulo(r,"izq");
      } else {//izq (ya chequeado)
        if(debug){println(" Agregar a la derecha ");}
        agregarRectangulo(r,"der");
      }
    } else {
      println("Error AgregarPalabra");
    }
  }
  public String columnaRandom() {//podria estar en main para ser mas gral
    float i= random(1.99);//0 o 1(1.99 por las dudas no sea cosa que tire un 2)
    if (i>0.5) {
      return "der";
    } else {
      return "izq";
    }
  }
  public int cantidadDeRectangles() {
    return this.rectangles.size();
  }
  public void dibujar() {
    for (Rectangle r : rectangles) {
      r.mostrar();
    }
  }
  public void agregarRectangulo(Rectangle rec ,String pos){
     if(pos.equals("rnd")){
       rec.ponerEnColumna(columnaRandom());
     }
     else{
       rec.ponerEnColumna(pos);
     }
     rec.darEspacioParaRandom(0-int(rec.Largo()), 0);
     rec.posicionarEnRow(this.numeroDeRow);
     this.rectangles.add(rec);
  }
  
}