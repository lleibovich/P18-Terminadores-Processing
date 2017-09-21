
ArrayList<Row> Rows= new ArrayList<Row>();
ArrayList<Rectangle> initRectangles = new ArrayList<Rectangle>();//se usa para simular las "words"
int cantRectangles=30;//para test
final float altoPalabra=32;//en pixeles
final float largoPalabra=100;

void setup() {
  size(1024, 768);//usar fullscreen
  background(255);
  fill(125);
}

void draw() {
  for (int i=0; i<cantRectangles; i++) {//lleno rectangles
    initRectangles.add( new Rectangle(new PVector(largoPalabra, altoPalabra)));//30 por palabra
  }
  int cantRows =height/int(altoPalabra);
  for (int i=0; i<cantRows; i++) {//lleno rows
    Row r=new Row();
    Rows.add(r);
  }
  for(int i=0; i<cantRows; i++){//agrego los rect a los row
    Row RowCandidato = Rows.get(int(random(-0.49, (Rows.size())-0.51)));//un row al azar
    while(RowCandidato.CantidadDeRectangles()<2){//si son menos de las pal por row(2)
       RowCandidato = Rows.get(int(random(-0.49, (Rows.size())-0.51)));
    }
    RowCandidato.AgregarPalabra(initRectangles.get(i));
  }
  //aca irian los merge para mas randomizidad(merge colums, merge rows)
  for(int i=0;i<cantRows;i++){//printeo los rect develop only
     Rows.get(i).Dibujar();//get
    
  }
}