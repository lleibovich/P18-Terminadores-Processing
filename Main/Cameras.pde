public class Cameras {
  public int cons = 0;
  public int[] xMov = new int[10];
  public int[] yMov = new int[10];
  
  private boolean init = false;
  private int aux = 0;
  private color[][] previousColors = new color[640][480];
  
  
  public void cameras() {
    if (video.available()) {
      video.read();
      video.loadPixels();
      
      int movementSum = 0;
      for (int x = 0; x < 640; x++) {
        for (int y = 0; y < 480; y++) {
          color currColor = video.pixels[y*640+x];
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
          
          if (diffR + diffG + diffB > 300 && init) {
            if (aux < 10) {xMov[aux] = x; yMov[aux] = y; aux++;}
          }
        }
      }
      init = true;
      
      if (movementSum > 1500000) {
        updatePixels();
        cons = round((movementSum - 1500000)/900000);
      }
    }
  }
}