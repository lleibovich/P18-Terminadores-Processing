class Rectangle {
  private PVector TopLeftPos;
  private PVector Size;
  private String col;//izq der
  private PVector EspacioRandomizable;

  public Rectangle(PVector size, PVector espacioRandomizable) {//constructor
    this.Size=size;
    this.EspacioRandomizable=espacioRandomizable;
    this.TopLeftPos=new PVector(0,0);
  }
  public float Largo() {
    return this.Size.x;
  }
  public float altura() {//no esta en uso
    return this.Size.x;
  }
  public void ponerEnColumna(String column) {
    this.col=column;
    if (this.col.equals("der")) { 
      TopLeftPos.x=(width/2);
    }
  }
  public String columna() {
    return col;
  }
  public void randomizar(String direccion) {
    if(direccion.equals("der")){
      this.TopLeftPos.x=this.TopLeftPos.x+(random(EspacioRandomizable.x));//x
      this.TopLeftPos.y=this.TopLeftPos.y+(random(EspacioRandomizable.y));//y
    }
    else if(direccion.equals("izq")){
      this.TopLeftPos.x=this.TopLeftPos.x-(random(EspacioRandomizable.x));//x
      this.TopLeftPos.y=this.TopLeftPos.y-(random(EspacioRandomizable.y));//y
    }
    else{
      println("Error randomizar");
    }
    this.EspacioRandomizable.set(0, 0);
  }
  public void darEspacioParaRandom(int x, int y,String direccion) {
    this.EspacioRandomizable.x=this.EspacioRandomizable.x+x;
    this.EspacioRandomizable.y=this.EspacioRandomizable.y+y;
    this.randomizar(direccion);
  }
  public void mostrar() {
    fill(random(240), random(240), random(240));
    rect(this.TopLeftPos.x, this.TopLeftPos.y, this.Size.x, this.Size.y);
  }
  public void posicionarEnRow(int row) {
    this.TopLeftPos.y=(this.Size.y)*row;
  }
}