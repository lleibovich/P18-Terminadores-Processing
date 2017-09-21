//int(random()) es por TRUNCAMIENTO
ArrayList<Row> Rows= new ArrayList<Row>();
ArrayList<Rectangle> initRectangles = new ArrayList<Rectangle>();//se usa para simular las "words"
int cantRectangles=30;//para test
final float altoPalabra=32;//en pixeles
final float largoPalabra=100;//float por pvector
void settings(){//algunas versiones piden settings para size
  size(1024, 768);//usar fullscreen
}
void setup() {
 // size(1024, 768);//usar fullscreen
  background(255);
  fill(125);
}

void draw() {
  for (int i=0; i<cantRectangles; i++) {//lleno rectangles
    initRectangles.add( new Rectangle(new PVector(largoPalabra, altoPalabra),new PVector(width/2, 0)));//30 por palabra
  }
  int cantRows =height/int(altoPalabra);
  for (int i=0; i<cantRows; i++) {//lleno rows
    Row r=new Row();
    Rows.add(r);
  }
  for(int i=0; i<cantRows; i++){//agrego los rect a los row
    Row RowCandidato = Rows.get(int(random( (Rows.size()-0.01))));//un row al azar //<>//
    while(RowCandidato.CantidadDeRectangles()<2){//si son menos de las pal por row(2)
       RowCandidato = Rows.get(int(random( (Rows.size()-0.01)))); //<>//
    }
    RowCandidato.AgregarPalabra(initRectangles.get(i));
  }
  //aca irian los merge para mas randomizidad(merge colums, merge rows)
  for(Row r : Rows){//printeo los rect develop only
     r.Dibujar(); //<>//
  }
}