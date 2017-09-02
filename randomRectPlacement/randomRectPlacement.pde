class Rectangle {
  public PVector TopLeftPos;
  public PVector Size;
  public int col;//0 si izq 1 si der
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
int aux;
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
      auxRowNum=int(random(-0.49, (Rows.size())-0.51));//un row aleatorio a aux
      auxRow = Rows.get(auxRowNum);//get
    }
    auxRowNum=auxRowNum + 1;//para poder multiplicar     
    if(auxRow.rectangles.size()==0){//asigno si va a la derecha o a la izq si no hay una palabra ya en esa row
      auxRect=initRectangles.get(p);     
      auxRect.TopLeftPos.y=altoPalabra*auxRowNum;//altura(renglon);
      auxRect.col=int(random(0,1));//si va a la der random =1 sino 0
      auxRect.TopLeftPos.x=(width/2)*int(auxRect.col);
    }
    else {//seria else if si fuesen mas de 2 //ver el que esta si esta a la der o izq y ponerlo del otro lado
      auxRect=auxRow.rectangles.get(0);//agarro el otro
      aux=auxRect.col;//get col y lo paso a la otra
      if(aux){//si 1 lo paso a 0
        aux=0;
      }
      else if(!aux){//viceversa
        aux=1;
      }
      else{
        color(255,0,0);
        rect(0,0,length,width);//error
      } 
      auxRect=initRectangles.get(p);
      auxRect.col=aux;
      auxRect.TopLeftPos.y=altoPalabra*auxRowNum;//altura(renglon);
      auxRect.TopLeftPos.x=(width/2)*int(auxRect.col);    
    }
    auxRow.rectangles.add(auxRect);//le agrego a ese row el rectangle "p"
    //falta rect vect
  }
  for(int i=0;i<cantRows;i++){//printeo los rect develop only
    auxRow = Rows.get(i);//get
    for(aux=0;i<palabrasPorRow;aux++){//falta el random dentro del row
       auxRect=auxRow.rectangles.get(i);
       rect(auxRect.TopLeftPos.x,auxRect.TopLeftPos.y,Size.x,Size.y);
    }
  }
}