class Row {
  protected ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();//serian 2 por row por ahora
  //  protected float espacioVacioIzquierda=(width/2);//cantidad de espacio disponible para variar randomente
  // protected float espacioVacioDerecha = (width/2);//deberia ser entero pero por mantener tipos
<<<<<<< HEAD
  public int numeroDeRow;
  public Row(int n){//contructor
    this.numeroDeRow=n;
  }
  public int cantidadDePalabras() {
    return this.rectangles.size();
  } 
  public void agregarPalabra(Rectangle r) {//un poco largo se debe poder mejorar
    if(debug){println("agregarPalabra ");}
    if (this.contenido().equals("nada")) {
      if(debug){print("Size = 0 ");}
      agregarRectangulo(r,"rnd");
    } 
    
    else if (this.contenido().equals("izq")) {
      if(debug){print("Size = 1 ");}
      if(debug){println(" Agregar a la izquierda ");}
      agregarRectangulo(r,"izq");
    } 
    else if(this.contenido().equals("izq")){
       if(debug){print("Size = 1 ");}
       if(debug){println(" Agregar a la derecha ");}
       agregarRectangulo(r,"der");
=======
  public int CantidadDePalabras() {
    return this.rectangles.size();
  }
  public void AgregarPalabra(Rectangle r) {//un poco largo se debe poder mejorar
    Rectangle aux ;
    if(debug){println("AgregarPalabra ");}
    if (this.rectangles.size()==0) {
      if(debug){print("Size = 0 ");}
      r.PonerEnColumna(ColumnaRandom());
      this.SacarEspacio(r);
      this.rectangles.add(r);
    } else if (this.rectangles.size()==1) {
      if(debug){print("Size = 1 ");}
      aux=rectangles.get(0);
      if (aux.Columna().equals("der")) {
        if(debug){println(" Add a la izq ");}
        r.PonerEnColumna("izq");
        this.SacarEspacio(r);
        this.rectangles.add(r);
      } else {//izq (ya chequeado)
        if(debug){println(" Add a la der ");}
        r.PonerEnColumna("der");
        this.SacarEspacio(r);
        this.rectangles.add(r);
      }
    } else {
      println("Error AgregarPalabra");
>>>>>>> parent of 500397c... Mucho mejor(1.1)
    }
    else{println("Error agregarPalabra");}
  }
  public String columnaRandom() {//podria estar en main para ser mas gral
    float i= random(1.99);//0 o 1(1.99 por las dudas no sea cosa que tire un 2)
    if (i>0.5) {
      return "der";
    } else {
      return "izq";
    }
  }
<<<<<<< HEAD
  public String contenido() {//returns "izq" "der" "dos" "nada"
    if(this.rectangles.size()==0){
      return "nada";
    }
    else if(this.rectangles.size()==2){
      return "dos";
    }
    Rectangle r = this.rectangles.get(0);
    if(r.columna().equals("izq")){
      return "izq";
    }
    else if (r.columna().equals("izq")){
      return"der";
    }
    else{
      println("error columnaRandom");
    }
    return"error";
=======
  public void SacarEspacio(Rectangle r) {//saca la cantidad de espacio que ocupa la palabra
    r.DarEspacioParaRandom(0-int(r.Largo()), 0);
  }
  public int CantidadDeRectangles() {
    //println(width/2);
    return this.rectangles.size();
>>>>>>> parent of 500397c... Mucho mejor(1.1)
  }
  public void dibujar() {
    for (Rectangle r : rectangles) {
      r.mostrar();
    }
  }
<<<<<<< HEAD
  public void agregarRectangulo(Rectangle rec ,String pos){
     if(pos.equals("rnd")){
       rec.ponerEncolumna(columnaRandom());
     }
     else{
       rec.ponerEncolumna(pos);
     }
     rec.darEspacioParaRandom(0-int(rec.Largo()), 0);
     rec.posicionarEnRow(this.numeroDeRow);
     this.rectangles.add(rec);
  }
=======
>>>>>>> parent of 500397c... Mucho mejor(1.1)
}