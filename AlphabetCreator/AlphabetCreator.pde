int pixelSteps = 6; // Amount of pixels to skip -> configurar
ArrayList<String> words = new ArrayList<String>();
color bgColor = color(255, 100);
String fontName = "Arial Bold";

ArrayList<Word> wordsArray = new ArrayList<Word>();
PGraphics pg;
// Makes all particles draw the next word
void nextWord(String word) {
  // Draw word in memory
  pg.beginDraw();
  pg.clear();
  pg.fill(255);
  pg.textSize(32);
  pg.textAlign(LEFT);
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
   int x0 = width;
   int y0 = height;
   // Searches initial X,Y for the word.
   for (Point p : this.points) {
     if (p.x < x0) x0 = p.x;
     if (p.y < y0) y0 = p.y;
   }
   print("X0: ");
   print(x0);
   print(" - Y0:");
   println(y0);
   // Sets all X,Y from all points relative to x0,y0
   for (Point p : this.points) {
     p.x = p.x - x0;
     p.y = p.y - y0;
   }
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


int i = 0;
PrintWriter output;

void setup() {
  size(800, 600);
  background(255);
  output = createWriter("Alphabet.txt");
  pg = createGraphics(width, height);

  words.add("Fear one");
  words.add("Fear two");
  words.add("Fear three");
  words.add("Fear four");
  words.add("Fear five");
  words.add("Fear six");
  words.add("Fear seven");
  words.add("Fear eight");
  words.add("Fear nine");
  words.add("Fear ten");
  words.add("Strength one");
  words.add("Strength two");
  words.add("Strength three");
  words.add("Strength four");
  words.add("Strength five");
  words.add("Strength six");
  words.add("Strength seven");
  words.add("Strength eight");
  words.add("Strength nine");
  words.add("Strength ten");
}

void draw() {
  if (i == words.size()) {
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
  } else {
    nextWord(words.get(i));
    i++;
  }
}