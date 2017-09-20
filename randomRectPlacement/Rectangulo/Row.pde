class Row {
  protected ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();//serian 2 por row por ahora
  protected int espacioVacioIzquierda=(width/2 );//cantidad de espacio disponible para variar randomente
  protected int espacioVacioDerecha = (width/2);
  
  public int CantidadDePalabras(){
   return this.rectangles.size();
  }
  public void AgregarPalabra(Rectangle r){
   
   if(this.rectangles.size()==0){
     r.PonerEnColumna(ColumnaRandom());
     this.VaciarEspacio(r);
     this.rectangles.add(r);
   }
   else if(this.rectangles.size()==1){
     Rectangle aux = new Rectangle;
     aux=rectangles.get(0);
     if(aux.Columna.equals("der")){
       r.PonerEnColumna("izq");
       this.VaciarEspacio(r);
       this.rectangles.add(r);
     }
     else{//izq (ya chequeado)
       r.PonerEnColumna("der");
       this.VaciarEspacio(r);
       this.rectangles.add(r);
     }
   }
   else{
       println("Error AgregarPalabra");
   }
 }
 public String ColumnaRandom(){//deberia estar en main pra ser mas gral
   float i= random(1);
   if(i>0.5){
     return "der";
   }
   else{
     return "izq";
   } 
 }
 public void VaciarEspacio(Rectangle r){
   if(r.Columna.equals("der")){
     this.espacioVacioDerecha=this.espacioVacioDerecha-r.Largo;
   }
   else if(r.Columna.equals("izq")){
     this.espacioVacioIzquierda=this.espacioVacioIzquierda-r.Largo;
   }
   else{
     println("Error VaciarEspacio");
   }
 }
}
  