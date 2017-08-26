class Rectangle {
  public PVector TopLeftPos;
  public PVector Size;
  public int pos;//1 si izq 2 si der
  public Rectangle(PVector size) {
    this.Size=size;
  }
}
class Row {
  public ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();//serian 2 por row por ahora
}
ArrayList<Row> Rows= new ArrayList<Row>();
public ArrayList<Rectangle> initRectangles = new ArrayList<Rectangle>();//se usa para simular las "words"
int cantRectangles=30;//para test
final float altoPalabra=32;
final float largoPalabra=100;
final int palabrasPorRow=2;
Row auxRow;
Rectangle auxRect;
int auxRowNum=0;
void setup() {
  size(1024, 768);
  background(255);
  fill(125);
}

void draw() {
  for (int i=0; i<cantRectangles; i++) {//inicializacion de rectangles
    initRectangles.add( new Rectangle(new PVector(largoPalabra, altoPalabra)));//30 por palabra
  }
  int cantRows =height/int(altoPalabra);
  for (int i=0; i<cantRows; i++) {//inicializacion rows
    Rows.add(new Row());
  }
  int p =0;
  while (p<=cantRectangles) { 
    while(auxRow.rectangles.size()<palabrasPorRow){//si son menos de las pal por row
      auxRowNum=int(random(0, Rows.size()));//un row aleatorio a aux
      auxRow = Rows.get(auxRowNum);//get
    }
    auxRect=initRectangles.get(p);
    auxRect.TopLeftPos.y=altoPalabra*auxRowNum;
    if(auxRow.rectangles.size()==0){//asigno si va a la derecha o a la izq si no hay una palabra ya en esa row
      auxRect.TopLeftPos.x=(width/2)*int(random(0,1));//si va a la der random =1 sino 0
    }
    else {//seria else if si fuesen mas de 2
      //ver el que esta si esta a la der o izq y ponerlo del otro lado
    }
    auxRow.rectangles.add(auxRect);//le agrego a ese row el rectangle "p"
    //falta rect vect
  }
  for(int i=0;i<cantRows;i++){//printeo los rect develop only
    
  }
}