public class Cameras {
  public int cons = 0;
  public PVector[] movement = new PVector[10];
  public boolean[][] movementMap;// = new boolean[2][this.config.RowsQuantity];
  
  private boolean init = false;
  private int aux = 0;
  private final int camWidth = 640;
  private final int camHeight = 480;
  private color[][] previousColors = new color[camWidth][camHeight];
  private Configuration config;
  private float sensibility = (100 - 10) * 10000; // El 10 tiene que ser reemplazado por el valor del config
  
  public Cameras(Configuration cfg) {
    this.config = cfg;
    sensibility = (100 - this.config.CameraSensibility) * 10000;
    movementMap = new boolean[this.config.ColsQuantity][this.config.RowsQuantity];
  }
  
  public void cameras() {
    if (video.available()) {
      video.read();
      video.loadPixels();
      
      int movementSum = 0;
      for (int x = 0; x < camWidth; x++) {
        for (int y = 0; y < camHeight; y++) {
          color currColor = video.pixels[y*camWidth+x];
          color prevColor = previousColors[x][y];
          int currR = (currColor >> 16) & 0xFF;
          int currG = (currColor >> 8) & 0xFF;
          int currB = currColor & 0xFF;
          
          int prevR = (prevColor >> 16) & 0xFF;
          int prevG = (prevColor >> 8) & 0xFF;
          int prevB = prevColor & 0xFF;
          
          int diffR = abs(currR - prevR);
          int diffG = abs(currG - prevG);
          int diffB = abs(currB - prevB);
          
          movementSum += diffR + diffG + diffB;
          
          previousColors[x][y] = currColor;
          
          if (aux != 0 && movement[aux-1] == null) movement[aux-1] = new PVector();
          if (diffR + diffG + diffB > 300 && init) {
            if (aux == 0 || aux < 10 && movement[aux-1].x+20 < x && movement[aux-1].y+20 < y) { //<>//
              movement[aux] = new PVector(x, y);
              aux++;
            }
          }
        }
      }
      init = true;
      
      if (movementSum > 1500000) {
        cons = round((movementSum - 1500000)/sensibility);
      }
      float zoneWidth = camWidth / this.config.ColsQuantity;
      float zoneHeight = camHeight / this.config.RowsQuantity;
      for (int i = 0; i < movement.length; i++) {
        if (movement[i] == null) continue;
        int colNumber = int(movement[i].x / zoneWidth);
        int rowNumber = int(movement[i].y / zoneHeight);
        if (colNumber == this.config.ColsQuantity) {
          colNumber = this.config.ColsQuantity - 1;
        }
        if (rowNumber == this.config.RowsQuantity) {
          rowNumber = this.config.RowsQuantity - 1;
        }
        // Si detecta en el medio va a alguno de los dos costados
        if (colNumber == 1) {
          if (millis() % 2 == 0) colNumber = colNumber + 1;
          else colNumber = colNumber - 1;
        }
        movementMap[colNumber][rowNumber] = true;
      }
    }
  }
  public void clvar() {
    aux = 0;
    movement = new PVector[10];
    movementMap = new boolean[this.config.ColsQuantity][this.config.RowsQuantity];
  }
}