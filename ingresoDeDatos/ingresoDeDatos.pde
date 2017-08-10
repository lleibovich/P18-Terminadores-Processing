/*
processing 3.3.5
*/
//aparentemente los key pressed no funcionan adentro de un while
//cada renglon seria 50 a este tamanip
//constantes
String inicialS= "un miedo";
String finalS ="una fortaleza";
int anchoRenglon =25;
//int cantCaract = 20;
String auxS ="";
char car=0;
//arrays
ArrayList<String> palInicial = new ArrayList<String>();
ArrayList<String> palFinal = new ArrayList<String>();
PFont font;
int p = 1;
boolean inicial = true;
boolean fin =false;

void setup(){
   size(900,600);//combiene asi para testing , fulscreen release
   //fullScreen();
   background(255);
   font = createFont("Arial Bold",32);//ver de cambiar tamanio
   textFont(font);
   noStroke();
   smooth();
}

void draw(){
  fill(0);
  if (keyPressed){//al apretar
    car = key;
    
  }
  if(car== ENTER&&(!keyPressed)){//al presionar enter
    if(inicial){//inicial
      palInicial.add(auxS);//cargo el array
      inicial=false;//cambio de array
    }
    else{//final
      palFinal.add(auxS);//cargo el array
      inicial=true;//cambio de array
      p=p+1;
    }
    blanquearRenglon(2);
    auxS="";//vacio aux
    car = 0;//bacio el caracter
  }
  else if(car==BACKSPACE &&(!keyPressed)){//borrar  
    auxS="";
    car = 0;//solo un caracter 
  }
  else if(car==ESC&&(!keyPressed)){
    fin=true;
    car = 0;
  }
  else if((car != 0)&&(!keyPressed)){//al soltar  
    auxS=auxS+str(car);
    car = 0;
    
  }
  if(inicial){
    blanquearRenglon(1);
    text("escribir "+inicialS, 10, 24);
  }
  else if(!inicial){
    blanquearRenglon(1);
    text("escribir "+finalS, 10, 24);
  }
  blanquearRenglon(2);
  text(auxS, 10, 50);
}
void blanquearRenglon(int r){
  fill(255);//cuadrado blanco para borrar lo ingresado
  rect(0,(anchoRenglon*r)-(anchoRenglon*r),width,anchoRenglon*r);//asi queda mas suave
  fill(0);//mas estetico sino que da rugoso
}
//http://www.puerta18.org.ar/