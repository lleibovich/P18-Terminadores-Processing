public class KinectMov {
  private int time = 0;
  public int cons = 0;
  
  private final int[] partes = {7,11,13,17};
  
  private int[] skely = new int[24];
  private int[] skelx = new int[24];

  public void total() {
    int todo = movimiento();
    if (todo != 0) {cons = todo;}
    thread("total");
  }
  
  private int auxiliar() {
    int todo = 0;
    for(int l = 0; l < bodies.size() ;l++) {
      SkeletonData _s = bodies.get(l);
      for (int p = 0; p < 4; p++) {
        if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],60)) {
          if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],50)) {
            if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],40)) {
              if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],30)) {
                if (det(_s, partes[p],skelx[l*4+p],skely[l*4+p],20)) {
                } else {todo = todo + 2;}
              } else {todo = todo + 3;}
            } else {todo = todo + 4;}
          } else {todo = todo + 5;}
        } else {todo = todo + 6;}
      }
      randomSeed(hour()*10000+minute()*100+second());
      todo = todo + (int)random(0,2);
    }
    return todo;
  }
  
  
  private int movimiento() {
    if (time <= millis()-1000 && time != 0) {time = 0; return auxiliar();}
    
    // Guardar posición de cada parte del cuerpo
    while (time == 0) {
      for (int l = 0; l<bodies.size(); l++) {
      SkeletonData _s = bodies.get(l);
      skelx[l*4]=(int)pos(_s,partes[1],'x'); skely[l*4]=(int)pos(_s,partes[1],'y');
      skelx[l*4+1]=(int)pos(_s,partes[2],'x'); skely[l*4+1]=(int)pos(_s,partes[2],'y');
      skelx[l*4+2]=(int)pos(_s,partes[3],'x'); skely[l*4+2]=(int)pos(_s,partes[3],'y');
      skelx[l*4+3]=(int)pos(_s,partes[4],'x'); skely[l*4+3]=(int)pos(_s,partes[4],'y');
      }
      time = millis();
    }
    //int time = millis();
    //while (time+1000 < millis()){};// Espera un segundo
    return 0;
   } // Detecta si el usuario se movio de la posición indicada con cada parte del cuerpo
    
  
  private float pos(SkeletonData _s, int b, char c) { // Toma la posición del cuerpo en cuestion
    if (c == 'x') {return _s.skeletonPositions[b].x*width;}
    if (c == 'y') {return _s.skeletonPositions[b].y*height;}
    if (c == 'z') {return _s.skeletonPositions[b].z*-8000;}
    else return Kinect.NUI_SKELETON_POSITION_NOT_TRACKED;
  }
  
  private boolean det(SkeletonData _s, int s, int x, int y, int d) { // Detecta si el cuerpo está en un lugar especifíco, o en un radio
    if (pos(_s, s, 'x') >= x-d && pos(_s, s, 'x') <= x+d) {
          if (pos(_s, s, 'y') >= y-d && pos(_s, s, 'y') <= y+d) {
            return true;
          } else {return false;}
        } else {return false;}
  }
}