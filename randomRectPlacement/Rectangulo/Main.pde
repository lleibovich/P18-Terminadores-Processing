//int(random()) es por TRUNCAMIENTO //<>// //<>// //<>//
ArrayList<Row> rows= new ArrayList<Row>();
ArrayList<Rectangle> initRectangles = new ArrayList<Rectangle>();//se usa para simular las "words"
final boolean debug = true;
final int cantRectangles=30;//para test
final int altoPalabra=32;//en pixeles
final float largoPalabra=100;//float por pvector
//final int cantrows =(height/altoPalabra);
void settings() {//algunas versiones piden settings para size
  size(1024, 768);//usar fullscreen
}
void setup() {
  // size(1024, 768);//usar fullscreen
  background(255);
  fill(125);
}

void draw() {
  for (int i=0; i<cantRectangles; i++) {//lleno rectangles
    initRectangles.add( new Rectangle(new PVector(largoPalabra, altoPalabra), new PVector(width/2, 0)));//30 por palabra
  }
  if(debug){println("Fin init rect");}
  for (int i=0; i<height/altoPalabra; i++) {//agrego rows
    Row r=new Row(i);
    rows.add(r);
  }
  if(debug){println("Fin init rows ");}
  if(debug){println("con " + rows.size()+" rows");}
  for (int i=0; i<cantRectangles; i++) {//agrego los rect a los row
    Row RowCandidato = rows.get(int(random( (rows.size()-0.01))));//un row al azar
    while (RowCandidato.contenido().equals("dos")) {//si mas de la cantidad por row
      RowCandidato = rows.get(int(random( (rows.size()-0.01))));
    }
    RowCandidato.agregarPalabra(initRectangles.get(i));
  }
  if(debug){println("Fin rect to rows");}
  //aca irian los merge para mas randomizidad(merge colums, merge rows)
  for (Row r : rows) {//printeo los rect develop only
    r.dibujar();
  }
  noLoop();
}