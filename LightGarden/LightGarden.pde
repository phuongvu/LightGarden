import processing.serial.*;

Serial port;
NoiseCurve curve;
color c;
boolean mouseDown = false;
boolean fade = false;
boolean presentMode = false;
String mode = "curve";
float curveOpacity = 24;
float starOpacity = 165;
PGraphics overlay;
PGraphics drawing;
GameInput controller;
int frameCnt = 0;
int fadeRate = 3;

float rotation = 0;

boolean rotate = false;

int colorIndex = 0;

color hues[] = {207,222,268,152};

boolean useController = false;
boolean btnDown = false;
float cx, cy, centerX, centerY;

LightBrush currentBrush, starfieldBrush, starburstBrush, convergeBrush, squiggleBrush;
ArrayList<LightBrush> brushes;
int brushIndex = 0;

Pointer seed;

void setup() {
  size(1440, 900,P2D);
  controller = new GameInput();
  overlay = createGraphics(width,height);
  drawing = createGraphics(width,height);
  
  colorMode(HSB,360,255,255,255);
  
  noStroke();
  noCursor();
  frameRate(30);
  background(0);
  
  cx = width/2;
  cy = height/2;
  centerX = cx;
  centerY = cy;
  
  seed = new Pointer();
  
  brushes = new ArrayList<LightBrush>();
  squiggleBrush = new SquiggleBrush(seed);
  brushes.add(squiggleBrush);
  starburstBrush = new StarburstBrush(seed);
  brushes.add(starburstBrush);
  starfieldBrush = new StarfieldBrush(seed);
  brushes.add(starfieldBrush);
  convergeBrush = new ConvergeBrush(seed);
  brushes.add(convergeBrush);
  
  currentBrush = brushes.get(0);
  
  println(Serial.list());
  if(useController){
    port = new Serial(this, Serial.list()[5], 9600); 
  }
}
 
void draw() { 
  float xOffset = 0;
  float yOffset = 0;
  if(rotate){
    rotation += 0.009;
    xOffset = cos(rotation)*-width/2;
    yOffset = sin(rotation)*-height/2;
  }
  frameCnt++;
  checkInput();
  background(0);
  
  seed.update(mouseX,mouseY);
  
  currentBrush.update(drawing,overlay);
  
  pushMatrix();
  rotate(rotation);
  translate(xOffset,yOffset);
  image(drawing,0,0);
  popMatrix();
  
  if(!presentMode){
    image(overlay,0,0);
  }
  
}

void cycleBrush(){
  brushIndex++;
  if(brushIndex>brushes.size()-1){
    brushIndex=0;
  }
  currentBrush = brushes.get(brushIndex);
}

void checkInput(){
  ArrayList<String> hitKeys = controller.getHitKeys();
  for (String k : hitKeys){
    if (k.equals("1")||k.equals("2")||k.equals("3")||k.equals("4")||k.equals("5")||k.equals("6")||k.equals("7")||k.equals("8")||k.equals("9")){
      currentBrush.sym = Integer.parseInt(k);
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
      cycleBrush();
    }else if (k.equals("f")){
      currentBrush.bilateralSym = !currentBrush.bilateralSym;
    }else if (k.equals("h")){
      presentMode = !presentMode;
    }else if (k.equals("a")){
      useController = !useController;
      if(useController){
        port = new Serial(this, Serial.list()[5], 9600);
      }
    }else if (k.equals("k")){
      colorIndex++;
      if(colorIndex>hues.length-1){
        colorIndex = 0;
      }
    }else if (k.equals("r")){
      rotate = !rotate;
    }
  }
}

void mousePressed(){
  currentBrush.startStroke();
}

void mouseReleased(){
  currentBrush.endStroke();
}

color setColor(PGraphics layer, float opacity){
  int hue = currentHue();
  layer.colorMode(HSB,360,255,255,255);
  c = color(hue,255,178,opacity);
  layer.fill(c);
  return c;
}

color setColor(PGraphics layer, float brightness, float opacity){
  int hue = currentHue();
  layer.colorMode(HSB,360,255,255,255);
  c = color(hue,255,brightness,opacity);
  layer.fill(c);
  return c;
}

color cycleColor(PGraphics layer, float opacity){
  colorIndex++;
  int hue = currentHue();
  c = color(hue,255,178,opacity);
  layer.fill(c);
  return c;
}

int currentHue(){
  return hues[colorIndex];
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

 


