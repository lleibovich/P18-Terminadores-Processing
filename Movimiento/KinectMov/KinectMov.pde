import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
ArrayList <SkeletonData> bodies;

int[] cuerpos = {0,0,0,0,0,0}; // Es una prueba para ver si detecta hasta seis cuerpos

Kinect kinect;

void setup() {
  size(640, 480);
  kinect = new Kinect(this);
  smooth();
  bodies = new ArrayList<SkeletonData>();
  
}

void draw() {
  for (int i=0; i<bodies.size (); i++) {
    SkeletonData _s = bodies.get(i);
    if(movimiento(_s)) {} // Acá deberían poner lo que quieren que haga si detecta movimiento
  }
}

boolean movimiento(SkeletonData _s) {
  // Variables locales para puntos x e y de todo el cuerpo
  int[] skely = new int[20];
  int[] skelx = new int[20];
  
  // Guardar posición de cada parte del cuerpo
  for(int l = 0;l < 20;l++) {
    skelx[l]=(int)pos(_s,l,'x');
    skely[l]=(int)pos(_s,l,'y');
  }
  int time = millis();
  while (time+1000 < millis()){};// Espera un segundo
  
  // Detecta si el usuario se movio de la posición indicada cpn cada parte del cuerpo
  for(int l = 0;l < 20;l++) {
    if (det(_s,l,skelx[l],skely[l],10)){
    } else {return true;} // Devuelve verdadero si se movio
  }
  return false; // Devuelve falso si no lo hizo
}

float pos(SkeletonData _s, int b, char c) { // Toma la posición del cuerpo en cuestion
  if (c == 'x') {return _s.skeletonPositions[b].x*width;}
  if (c == 'y') {return _s.skeletonPositions[b].y*height;}
  if (c == 'z') {return _s.skeletonPositions[b].z*-8000;}
  else return Kinect.NUI_SKELETON_POSITION_NOT_TRACKED;
}

boolean det(SkeletonData _s, int s, int x, int y, int d) { // Detecta si el cuerpo está en un lugar especifíco, o en un radio
  if (pos(_s, s, 'x') >= x-d && pos(_s, s, 'x') <= x+d) {
        if (pos(_s, s, 'y') >= y-d && pos(_s, s, 'y') <= y+d) {
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
    for (int y = 0;y < 6; y++) {
      if (cuerpos[y] == 0) {bodies.add(_s); cuerpos[y] = _s.dwTrackingID;}
    }
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID || 0 == bodies.get(i).dwTrackingID) 
      {for (int y = 0;y < 6;y++) {
        if (cuerpos[y] == bodies.get(i).dwTrackingID) {bodies.remove(i); cuerpos[y] = 0;}
      }}
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