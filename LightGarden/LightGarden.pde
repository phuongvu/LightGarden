NoiseCurve curve;
float rotation = 0.0;
int curveSize = 180;
int markerSize = 20;
color c;
int sym = 5;
boolean mouseDown = false;
PGraphics overlay;
PGraphics drawing;
GameInput controller;

void setup() {
  size(1440, 900,P2D);
  controller = new GameInput();
  overlay = createGraphics(width,height);
  drawing = createGraphics(width,height);
  noStroke();
  noCursor();
  frameRate(30);
  fill(0);
  rect(0,0,width,height);
}
 
void draw() { 
  checkInput();
  
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
    curve = new NoiseCurve(p.dist/2+random(p.dist/2)+8,p);
    c = color(0,180,random(55)+200,12);
    curve.drawCurve(c,drawing);
  }
  drawing.endDraw();
}

void drawMarkers(ArrayList<RPoint> markers){
  overlay.beginDraw();
  overlay.noStroke();
  overlay.clear();
  overlay.fill(255,255,255,80);
  for (RPoint p : markers){
    overlay.ellipse(p.x,p.y,markerSize,markerSize);
    overlay.fill(255,255,255,40);
  }
  overlay.endDraw();
  image(overlay,0,0);
}

void checkInput(){
  ArrayList<String> hitKeys = controller.getHitKeys();
  for (String k : hitKeys){
    if (k.equals("1")||k.equals("2")||k.equals("3")||k.equals("4")||k.equals("5")||k.equals("6")||k.equals("7")||k.equals("8")||k.equals("9")){
      sym = Integer.parseInt(k);
    }else if (k.equals("c")){
      drawing.beginDraw();
      drawing.clear();
      drawing.endDraw();
    }
  }
}

void mousePressed(){
  mouseDown = true;
}

void mouseReleased(){
  mouseDown = false;
}

 


