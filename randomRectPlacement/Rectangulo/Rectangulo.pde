class Rectangle {
  private PVector TopLeftPos;
  private PVector Size;
  private String col;//izq der
  private PVector EspacioRandomizable; 
  public float Largo() {
    return this.Size.x;
  }
  public float Altura() {
    return this.Size.x;
  }
  public void PonerEnColumna(String column) {
    this.col=column;
    if (this.col.equals("der")) { 
      TopLeftPos.x=(width/2);
    }
  }
  public String Columna() {
    return col;
  }
  public Rectangle(PVector size, PVector espacioRandomizable) {//constructor
    this.Size=size;
    this.EspacioRandomizable=espacioRandomizable;
    this.TopLeftPos=new PVector(0,0);
  }
  public void Randomizar() {
    for (int i=0; i<=this.EspacioRandomizable.x; i++) {//x
      this.TopLeftPos.x=this.TopLeftPos.x+(random(1.99));
    }
    for (int i=0; i<=EspacioRandomizable.y; i++) {//y
      this.TopLeftPos.y=this.TopLeftPos.y+(random(1.99));
    }
    this.EspacioRandomizable.set(0, 0);
  }
  public void DarEspacioParaRandom(int x, int y) {
    this.EspacioRandomizable.x=this.EspacioRandomizable.x+x;
    this.EspacioRandomizable.y=this.EspacioRandomizable.y+y;
  }
  public void Mostrar() {
    fill(random(240), random(240), random(240));
    rect(this.TopLeftPos.x, this.TopLeftPos.y, this.Size.x, this.Size.y);
  }
}