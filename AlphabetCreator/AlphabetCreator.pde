int pixelSteps = 3; // Amount of pixels to skip -> configurar
ArrayList<String> words = new ArrayList<String>();
color bgColor = color(255, 100);
String fontName = "Arial Bold";

ArrayList<Word> wordsArray = new ArrayList<Word>();

// Makes all particles draw the next word
void nextWord(String word) {
  // Draw word in memory
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.fill(0);
  pg.textSize(100);
  pg.textAlign(CENTER);
  PFont font = createFont(fontName, 100);
  pg.textFont(font);
  pg.text(word, width/2, height/2);
  pg.endDraw();
  pg.loadPixels();

  // Next color for all pixels to change to
  color newColor = color(random(0.0, 255.0), random(0.0, 255.0), random(0.0, 255.0));


  // Collect coordinates as indexes into an array
  // This is so we can randomly pick them to get a more fluid motion
  ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();
  ArrayList<Point> points = new ArrayList<Point>();
  for (int i = 0; i < (width*height)-1; i+= pixelSteps) {
    coordsIndexes.add(i);
  }

  for (int i = 0; i < coordsIndexes.size (); i++) {
    int coordIndex = coordsIndexes.get(i);
    
    // Only continue if the pixel is not blank
    if (pg.pixels[coordIndex] != 0) {
      // Convert index to its coordinates
      int x = coordIndex % width;
      int y = coordIndex / width;
      points.add(new Point(x, y));
    }
  }
  wordsArray.add(new Word(word, points));
}
class Word {
  public String text;
  public ArrayList<Point> points;
  Word(String varText, ArrayList<Point> varPoints) {
   this.text = varText;
   this.points = varPoints;
  }
}
class Point {
  public int x;
  public int y;
  Point(int parX, int parY) {
    this.x = parX;
    this.y = parY;
  }
}

void setup() {
  size(700, 300);
  background(255);

  words.add("A");
  words.add("B");
  words.add("C");
  words.add("D");
  words.add("E");
  words.add("F");
  words.add("G");
  words.add("H");
  words.add("I");
  words.add("J");
  words.add("K");
  words.add("L");
  words.add("M");
  words.add("N");
  words.add("Ñ");
  words.add("O");
  words.add("P");
  words.add("Q");
  words.add("R");
  words.add("S");
  words.add("T");
  words.add("U");
  words.add("V");
  words.add("W");
  words.add("X");
  words.add("Y");
  words.add("Z");
  words.add("a");
  words.add("b");
  words.add("c");
  words.add("d");
  words.add("e");
  words.add("f");
  words.add("g");
  words.add("h");
  words.add("i");
  words.add("j");
  words.add("k");
  words.add("l");
  words.add("m");
  words.add("n");
  words.add("ñ");
  words.add("o");
  words.add("p");
  words.add("q");
  words.add("r");
  words.add("s");
  words.add("t");
  words.add("u");
  words.add("v");
  words.add("w");
  words.add("x");
  words.add("y");
  words.add("z");

  
  for (int i = 0; i < words.size(); i++) {
    nextWord(words.get(i));
  }
  PrintWriter output = createWriter("Alphabet.txt");
  for (Word w : wordsArray) {
    String str = w.text + ":";
    for (Point p : w.points) {
      str = str + str(p.x) + ";"+ str(p.y) + "|";
    }
    str = str.substring(0, str.length() - 1); 
    output.println(str);
  }
  output.flush();
  output.close();
  exit();
}