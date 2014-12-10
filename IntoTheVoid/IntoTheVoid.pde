import processing.serial.*;

Serial port;
NoiseCurve curve;
float rotation = 0.0;
int curveSize = 180;
float markerSize = 3;
color c;
int sym = 5;
boolean mouseDown = false;
boolean fade = false;
boolean bilateralSym = true;
boolean presentMode = false;
String mode = "curve";
float curveOpacity = 24;
float starOpacity = 95;
PGraphics overlay;
PGraphics drawing;
PGraphics layer;
GameInput controller;
int frameCnt = 0;
int fadeRate = 3;

boolean useController = false;
boolean btnDown = false;
float cx, cy, centerX, centerY;

void setup() {
  size(1440, 900,P2D);
  controller = new GameInput();
  overlay = createGraphics(width,height);
  drawing = createGraphics(width,height);
  layer = createGraphics(width,height);
  noStroke();
  noCursor();
  frameRate(30);
  fill(0);
  rect(0,0,width,height);
  
  cx = width/2;
  cy = height/2;
  centerX = cx;
  centerY = cy;
  
  println(Serial.list());
  if(useController){
    port = new Serial(this, Serial.list()[5], 9600); 
  }
}
 
void draw() { 
  frameCnt++;
  checkInput();
  background(0);
  ArrayList<RPoint> markers = new ArrayList<RPoint>();
  if(useController){
    markers = getRadialSymmetry(sym,cx,cy,centerX,centerY);
  }else{
    markers = getRadialSymmetry(sym);
  }
  if (mouseDown||(useController&&btnDown)){
    layer = createGraphics(width,height);
    if(mode.equals("curve")){
      drawCurves(markers,layer);
    }else if (mode.equals("star")){
      drawStars(markers,layer);
    }else if (mode.equals("burst")){
      drawBursts(markers,layer);
    }
    drawing.beginDraw();
    drawing.image(layer,0,0);
    if (bilateralSym){
      drawing.pushMatrix();
      drawing.scale(-1,1);
      drawing.translate(-width,0);
      drawing.image(layer,0,0);
      drawing.popMatrix();
    }
    drawing.endDraw();
  }//else{
    drawMarkers(markers);
    if(fade&&frameCnt>fadeRate){
      drawing.beginDraw();
      drawing.fill(0,0,0,5);
      drawing.rect(0,0,width,height);
      drawing.endDraw();
      frameCnt = 0;
    }
  //}
  //blend(drawing,0,0,width,height,0,0,width,height,SCREEN);
  image(drawing,0,0);
  //if(((!mouseDown&&!useController)||(useController&&!btnDown))&&!presentMode){
    image(overlay,0,0);
    if (bilateralSym){
      pushMatrix();
      scale(-1,1);
      translate(-width,0);
      image(overlay,0,0);
      popMatrix();
    }
  //}
  
}

void drawMarkers(ArrayList<RPoint> markers){
  overlay.beginDraw();
  overlay.noStroke();
  overlay.clear();
  markerSize = 20;
  overlay.fill(255,255,255,80);
  for (RPoint p : markers){
    overlay.ellipse(p.x,p.y,markerSize,markerSize);
    overlay.fill(255,255,255,40);
  }
  overlay.endDraw();
}

void drawCurves(ArrayList<RPoint> markers,PGraphics layer){
  layer.beginDraw();
  layer.noStroke();
  for (RPoint p : markers){
    curve = new NoiseCurve(p.dist/2+random(p.dist/2)+8,p);
    c = color(0,random(100),random(55)+200,curveOpacity);//color(255,255,255,12);//
    curve.drawCurve(c,layer);
  }
  layer.endDraw();
  
}

void drawStars(ArrayList<RPoint> markers,PGraphics drawing){
  drawing.beginDraw();
  drawing.noStroke();
  drawing.smooth(2);
  drawing.fill(255,255,255,60);
  c = color(0,random(180),random(55)+200,starOpacity);
  drawing.fill(c);
  for (RPoint p : markers){
    markerSize = 2+p.dist/340;
    float numPoints = p.dist/60;
    float spread = 9;
    drawing.ellipse(p.x,p.y,markerSize,markerSize);
    for (int i=0;i<numPoints;i++){
      float rx = random(p.dist/spread)-(p.dist/spread)/2;
      float ry = random(p.dist/spread)-(p.dist/spread)/2;
      c = color(0,random(180),random(55)+200,starOpacity);
      drawing.fill(c);
      drawing.ellipse(p.x+rx,p.y+ry,markerSize,markerSize);
    }
  }
  drawing.endDraw();
}

void drawBursts(ArrayList<RPoint> markers,PGraphics drawing){
  drawing.beginDraw();
  drawing.noStroke();
  drawing.smooth(2);
  drawing.fill(255,255,255,60);
  c = color(0,random(80),random(55)+200,starOpacity);
  drawing.fill(c);
  for (RPoint p : markers){
    markerSize = 2+p.dist/340;
    float offset = p.dist/10;
    drawing.ellipse(p.x,p.y,markerSize*1.8,markerSize*1.8);
    float ox = p.x + cos(p.rot)*offset;
    float oy = p.y + sin(p.rot)*offset;
    ArrayList<RPoint> bursts = getRadialSymmetry(sym,ox,oy,p.x,p.y);
    for (RPoint b: bursts){
      drawing.ellipse(b.x,b.y,markerSize,markerSize);
    }
  }
  drawing.endDraw();
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
      overlay.beginDraw();
      overlay.clear();
      overlay.endDraw();
    }else if (k.equals("l")){
      mode = "curve";
    }else if (k.equals("s")){
      mode = "star";
    }else if (k.equals("b")){
      mode = "burst";
    }else if (k.equals("f")){
      bilateralSym = !bilateralSym;
    }else if (k.equals("h")){
      presentMode = !presentMode;
    }else if (k.equals("a")){
      useController = !useController;
      if(useController){
        port = new Serial(this, Serial.list()[5], 9600);
      }
    }
  }
}

void mousePressed(){
  mouseDown = true;
}

void mouseReleased(){
  mouseDown = false;
}

void serialEvent(Serial myPort) { 
  if(useController){
     String s = myPort.readStringUntil('\n');
     if(s!=null){
       
      String data[] = split(s,",");
      println(data);
      if(data[0].equals("1")){
        btnDown = true;
      }else{
        btnDown = false;
      }
      float rx = Float.parseFloat(data[2]);
      float ry = Float.parseFloat(data[1]);
      float mx = map(rx,170,500,0,width);
      float my = map(ry,170,500,0,height);
      float ncx = constrain(mx,0,width);
      float ncy = constrain(my,0,height);
      cx = (cx+ncx)/2;
      cy = (cy+ncy)/2;
      println("Button pressed: "+btnDown+" X:"+cx+" Y:"+cy);
     }
  }
}

 


