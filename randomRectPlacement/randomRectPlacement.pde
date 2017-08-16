class Rectangle {
  public String Text="";
  public PVector BottomLeftPos= new PVector(0, 0);
  public PVector Size = new PVector(0, 0);
  public float Surface=Size.x * Size.y;
  public void rectangle(String Text,PVector Size){
    this.Size=Size;
    this.Text=Text;
  }
}
PVector v1;
float AlturaLetra = 32;
float AnchoLetra = 30;
void setup(){
  size(1600,900);
  //fullscreen();
}

void draw(){
  fill(125);
  Rectangle aux;
  aux = new Rectangle(); 
  v1 = new PVector (4*AnchoLetra,AlturaLetra);
  aux.rectangle("test",v1);//solo para probar
  int row = int(height/aux.Size.y);//this.size?//renglon
  int lettersPerRow = int(width /(aux.Size.x / aux.Text.length()));//largo div largo de una letra
  println(row);
  println(lettersPerRow);
}