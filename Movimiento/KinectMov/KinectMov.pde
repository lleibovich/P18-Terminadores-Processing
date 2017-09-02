import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
ArrayList <SkeletonData> bodies;

Kinect kinect;

void setup() {
  size(640, 480);
  kinect = new Kinect(this);
  smooth();
  bodies = new ArrayList<SkeletonData>();
  
}

void draw() {
  textSize(72);
  image(kinect.GetImage(),0,0);
  text(total(),width/2,height/2);
}

int total() {
  int todo = 0;
  int fmov;
  for (int i=0; i<bodies.size (); i++) {
    SkeletonData _s = bodies.get(i);
    fmov = movimiento(_s);
    todo = todo + fmov;
    println(fmov);
  }
  return todo;
}

int movimiento(SkeletonData _s) {
  // Variables locales para puntos x e y de todo el cuerpo
  int[] skely = new int[20];
  int[] skelx = new int[20];
  
  // Guardar posición de cada parte del cuerpo
  for(int l = 0;l < 20;l++) {
    skelx[l]=(int)pos(_s,l,'x');
    skely[l]=(int)pos(_s,l,'y');
  }
  //int time = millis();
  //while (time+1000 < millis()){};// Espera un segundo
  
  // Detecta si el usuario se movio de la posición indicada con cada parte del cuerpo
  for(int l = 0;l < 20;l++) {
    //if (!det(_s,l,skelx[l],skely[l],20)){
    //  return 2;
    //}
    //if (!det(_s,l,skelx[l],skely[l],30)){
    //  return 3;
    //}
    //if (!det(_s,l,skelx[l],skely[l],40)){
    //  return 4;
    //}
    //if (!det(_s,l,skelx[l],skely[l],50)){
    //  return 5;
    //}
    //if (!det(_s,l,skelx[l],skely[l],60)){
    //  return 6;
    //}
    if (det(_s,l,skelx[l],skely[l],60)) {
      if (det(_s,l,skelx[l],skely[l],50)) {
        if (det(_s,l,skelx[l],skely[l],40)) {
          if (det(_s,l,skelx[l],skely[l],30)) {
            if (det(_s,l,skelx[l],skely[l],20)) {
            } else {return 2;}
          } else {return 3;}
        } else {return 4;}
      } else {return 5;}
    } else {return 6;}
  }
  randomSeed(hour()*10000+minute()*100+second());
  return (int)random(0,2);
}

float pos(SkeletonData _s, int b, char c) { // Toma la posición del cuerpo en cuestion
  if (c == 'x') {return _s.skeletonPositions[b].x*width;}
  if (c == 'y') {return _s.skeletonPositions[b].y*height;}
  if (c == 'z') {return _s.skeletonPositions[b].z*-8000;}
  else return Kinect.NUI_SKELETON_POSITION_NOT_TRACKED;
}

boolean det(SkeletonData _s, int s, int x, int y, int d) { // Detecta si el cuerpo está en un lugar especifíco, o en un radio
  if (pos(_s, s, 'x') >= x-d && pos(_s, s, 'x') <= x+d) {
    println("En rango de x");
        if (pos(_s, s, 'y') >= y-d && pos(_s, s, 'y') <= y+d) {
          println("En rango de i");
          return true;
        } else {return false;}
      } else {return false;}
}

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID || 0 == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a)
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}