NoiseCurve curve;
float rotation = 0.0;
int curveSize = 180;
int markerSize = 20;
color c = color(0,0,255,8);
int sym = 9;
boolean mouseDown = false;
PGraphics overlay;
PGraphics drawing;

void setup() {
  size(1440, 900,P2D);
  overlay = createGraphics(width,height);
  drawing = createGraphics(width,height);
  noStroke();
  noCursor();
  frameRate(30);
  fill(0);
  rect(0,0,width,height);
}
 
void draw() { 
  fill(0);
  rect(0,0,width,height);
  ArrayList<RPoint> markers = getRadialSymmetry(sym);
  image(drawing,0,0);
  if (mouseDown){
    drawCurves(markers);
  }else{
    drawMarkers(markers);
  }
}

void drawCurves(ArrayList<RPoint> markers){
  drawing.beginDraw();
  drawing.noStroke();
  for (RPoint p : markers){
    curve = new NoiseCurve(p.dist,p);
    c = color(0,0,random(55)+200,2);
    curve.drawCurve(c,drawing);
  }
  drawing.endDraw();
}

void drawMarkers(ArrayList<RPoint> markers){
  overlay.beginDraw();
  overlay.noStroke();
  overlay.clear();
  overlay.fill(255,255,255,100);
  for (RPoint p : markers){
    overlay.ellipse(p.x,p.y,markerSize,markerSize);
    overlay.fill(255,255,255,60);
  }
  overlay.endDraw();
  image(overlay,0,0);
}

void mousePressed(){
  mouseDown = true;
}

void mouseReleased(){
  mouseDown = false;
}

 


