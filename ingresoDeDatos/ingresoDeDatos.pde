/*
processing 3.3.5
*/
//constantes
String inicialS= "inicial";
String finalS ="final";
//int cantCaract = 20;
String auxS ="";
String prevS ="";
char car=0;
//arrays
ArrayList<String> palInicial = new ArrayList<String>();
ArrayList<String> palFinal = new ArrayList<String>();
PFont font;
int p = 0;
boolean teclaPres = false;
boolean inicial = true;

void setup(){
   size(900,600);
   //fullScreen();
   background(255);
   font = createFont("Arial Bold",32);
   textFont(font);
}

void draw(){
  fill(0);
  if (keyPressed){//al apretar
    car = key;
  }
  if(car== ENTER){//al presionar enter
    if(inicial){//inicial
      palInicial.set(p,auxS);
      inicial=false;
    }
    else{//final
      palFinal.set(p,auxS);
      inicial=true;
      p=p+1;
    }
    
  }
  else if(car==BACKSPACE){//borrar  
    auxS=prevS;
    //falta borrar el display
  }
  else if((car != 0)&&(!keyPressed)){//al soltar  
    //print(car);
    //println(auxS);
    prevS=auxS;
    auxS=auxS+str(car);
    car = 0;
    
  }
  //text("Test", 10, 24);
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