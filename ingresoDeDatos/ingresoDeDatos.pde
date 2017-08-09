/*
processing 3.3.5
*/
//aparentemente los key pressed no funcionan adentro de un while
//cada renglon seria 50 a este tamanip
//constantes
String inicialS= "un miedo";
String finalS ="una fortaleza";
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
    fill(255);//cuadrado blanco para borrar lo ingresado
    rect(0,25,width,50);
    fill(0);
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
    fill(255);
    rect(0,0,width,25);
    fill(0);
    text("escribir "+inicialS, 10, 24);
  }
  else if(!inicial){
    fill(255);
    rect(0,0,width,25);
    fill(0);
    text("escribir "+finalS, 10, 24);
  }
  fill(255);//cuadrado blanco para borrar lo ingresado
  rect(0,25,width,50);//asi queda mas suave
  fill(0);//mas estetico sino que da rugoso
  text(auxS, 10, 50);
}