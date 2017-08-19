class Rectangle {
  public PVector TopLeftPos;
  public PVector Size;
  public Rectangle(PVector size){
    this.Size=size;
  }
}
class Row {
  public ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();
}
ArrayList<Row> Rows= new ArrayList<Row>();
public ArrayList<Rectangle> initRectangles = new ArrayList<Rectangle>();//se usa para simular las "words"
int cantCuadrados=30;//para test
final float altoPalabra=32;
final float largoPalabra=100;
void setup(){
  size(1024,768);
  background(255);
  fill(125);
  
}
void draw(){
  for(int i=0;i<cantCuadrados;i++){
    initRectangles.add( new Rectangle(new PVector(largoPalabra,altoPalabra)));//30 por palabra
  }
  while(i<=cantCuadrados){
  }
}