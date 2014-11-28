NoiseCurve curve;
float rotation = 0.0;
int curveSize = 500;
color c = color(0,0,255,16);
int sym = 12;

void setup() {
  size(1440, 900,P2D);
  noStroke();
  noCursor();
  frameRate(12);
  fill(0);
  rect(0,0,width,height);
}
 
void draw() { 
  fill(0,0,0,8);
  rect(0,0,width,height);
  ArrayList<RadSymPoint> markers = getRadialSymmetry(sym);
  for (RadSymPoint p : markers){
    curve = new NoiseCurve(curveSize,p);
    c = color(0,0,random(55)+200,16);
    curve.drawCurve(c);
  }
}

 


