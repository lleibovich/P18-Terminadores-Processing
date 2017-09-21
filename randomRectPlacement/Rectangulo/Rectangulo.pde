class Rectangle {
  private PVector TopLeftPos;
  private PVector Size;
  private String col;//izq der
  public float Largo(){
    return this.Size.x;
  }
  public float Altura(){
    return this.Size.x;
  }
  public void PonerEnColumna(String column){
    col=column;
    if(col.equals("der")){ 
      TopLeftPos.x=width/2;
    }
  }
   public String Columna(){
    return col;
  }
  public Rectangle(PVector size) {//constructor
    this.Size=size;
  }
 
}