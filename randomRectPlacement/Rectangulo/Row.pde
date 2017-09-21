class Row {
  protected ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();//serian 2 por row por ahora
//  protected float espacioVacioIzquierda=(width/2);//cantidad de espacio disponible para variar randomente
 // protected float espacioVacioDerecha = (width/2);//deberia ser entero pero por mantener tipos
  public int CantidadDePalabras(){
   return this.rectangles.size();
  }
  public void AgregarPalabra(Rectangle r){//un poco largo se debe poder mejorar
  Rectangle aux ;
   
   if(this.rectangles.size()==0){
     r.PonerEnColumna(ColumnaRandom());
     this.DarEspacio(r);
     this.rectangles.add(r);
   }
   else if(this.rectangles.size()==1){
     aux=rectangles.get(0);
     if(aux.Columna().equals("der")){
       r.PonerEnColumna("izq");
       this.DarEspacio(r);
       this.rectangles.add(r);
     }
     else{//izq (ya chequeado)
       r.PonerEnColumna("der");
       this.DarEspacio(r);
       this.rectangles.add(r);
     }
   }
   else{
       println("Error AgregarPalabra");
   }
 }
 public String ColumnaRandom(){//podria estar en main para ser mas gral
   float i= random(1.99);//0 o 1(1.99 por las dudas no sea cosa que tire un 2)
   if(i>0.5){
     return "der";
   }
   else{
     return "izq";
   } 
 }
 public void DarEspacio(Rectangle r){//saca la cantidad de espacio que ocupa la palabra
   r.DarEspacioParaRandom(0-int(r.Largo()),0);
 }
 public int CantidadDeRectangles(){
     return this.rectangles.size();
 }
 public void Dibujar(){
     for (Rectangle r : rectangles) {
      r.Mostrar();
    }
 }
}