class Rectangle {
  public String Text="";
  public int row ;
  public int largo;
  public Rectangle(String Text,int largo){
    this.largo=largo;
    this.Text=Text;
  }
}
int auxRow;
int i =0;
PVector v1;
float AlturaLetra = 32;
float AnchoLetra = 30;
String word = "test"; 
String [][] list;//seria Word [][]
//public PVector BottomLeftPos; //resultado
int pals =0;
ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();
int cantCuadrados=25;
void setup(){
  size(1600,900);
  background(255);
  fill(125);
  
}
void draw(){
  for( i=0;i<cantCuadrados;i++){
    rectangles.add( new Rectangle(word,word.length()));
  }
  int row = int(height/AlturaLetra);//renglon
  int lettersPerRow = int(width /AnchoLetra);//el largo dividido por el largo de una letra
  int []rows=new int[row];
  list =new String[row][pals];
  for( i =0;i<rows.length;i++){//inicializacion
    rows[i]=lettersPerRow;
  }
  while(i<=cantCuadrados){
    auxRow=int(random(float(row)));
    while(rows[auxRow]<){
      
    }
    
    //le bajo la cant de letras disp
    //le asigno el obj a rectangles
    //agarro row por row y segun la cantidad de palabras agrego espacios en blanco
    //si son 2 por ej no suma x offset (final)
    //le agrego a la segunda(medio)
    //le agrego a ambas (adelante)
    //de forma random
    //retorno valores
    
    i++;
  }
}