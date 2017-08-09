/*
processing 3.3.5
*/
//constantes
//int cantCaract = 20;
String auxS ="";
char car=0;
//arrays
ArrayList<String> palInicial = new ArrayList<String>();
ArrayList<String> palFinal = new ArrayList<String>();
PFont font;
boolean teclaPres = false;

void setup(){
   //size(1600,900);
    fullScreen();
   background(255);
   font = createFont("Arial Bold",32);
   textFont(font);
}

void draw(){
  fill(0);
  if (keyPressed){//al apretar
    car = key;
  }
  if((car != 0)&&(!keyPressed)){//al soltar  
    //print(car);
    //println(auxS);
    auxS=auxS+str(car);
    car = 0;
    
  }
  text(auxS, 10, 50);
}

/*
void keyPressed() {
  teclaPres=true;
}

void keyReleased() {
  teclaPres=false;
}
*/