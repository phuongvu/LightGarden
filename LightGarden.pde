import processing.serial.*;

public void init() { //For removing window border
  frame.removeNotify(); 
  frame.setUndecorated(true); 
  frame.addNotify(); 
  super.init();
}

Serial port;
NoiseCurve curve;
color c;
boolean mouseDown = false;
boolean fade = false;
boolean presentMode = false;
String mode = "curve";
float curveOpacity = 24;
float starOpacity = 165;
float threadOpacity = 24;
PGraphics overlay, overlay2;
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
LightBrush brush1, brush2;
ArrayList<LightBrush> brushes;
int brushIndex = 0;

Pointer seed1, seed2;

void setup() {
  size(2560,720,P2D);
  frame.setLocation(1262,0);
  controller = new GameInput();
  overlay = createGraphics(width,height);
  overlay2 = createGraphics(width,height);
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
  
  seed1 = new Pointer();
  seed2 = new Pointer();
  
  brushes = new ArrayList<LightBrush>();
  squiggleBrush = new SquiggleBrush(seed2);
  brushes.add(squiggleBrush);
  starburstBrush = new StarburstBrush(seed1);
  brushes.add(starburstBrush);
  starfieldBrush = new StarfieldBrush(seed2);
  brushes.add(starfieldBrush);
  convergeBrush = new ConvergeBrush(seed2);
  brushes.add(convergeBrush);
  
  currentBrush = brushes.get(1);
  brush1 = brushes.get(1);
  brush2 = brushes.get(3);
  
  println(Serial.list());
  if(useController){
    port = new Serial(this, Serial.list()[5], 9600); 
  }
}
 
void draw() { 
  
  float xOffset = 0;
  float yOffset = 0;
  frameCnt++;
  checkInput();
  background(0);
  
  //seed.update(mouseX,mouseY);
  //seed.update(cx,cy);
  
  brush1.update(drawing,overlay);
  brush2.update(drawing,overlay2);
  
  image(drawing,0,0);
  
  if(!presentMode){
    image(overlay,0,0);
    image(overlay2,0,0);
  }
  /*drawing.beginDraw();
  drawing.fill(0,19);
  drawing.rect(0,0,width,height);
  drawing.endDraw();*/
  
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
  
  /*if(currentBrush.brushDown){
    if(!btnDown){
      currentBrush.endStroke();
    }
  }else{
    if(btnDown){
      currentBrush.startStroke();
    }
  }*/
  
  
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
       s = s.substring(1,s.length()-3);
      try {
        String data[] = split(s,",");
        println(data);
        if(data[0].equals("0")){
          //Controller 1:
          if(data[1].equals("0")){
            if(!seed1.down){
              brush1.startStroke();
            }
            seed1.down = true;
          }else{
            if(seed1.down){
              brush1.endStroke();
            }
            seed1.down = false;
          }
          float rx = Float.parseFloat(data[2]);
          float ry = Float.parseFloat(data[3]);
          float mx = map(rx,-1,1,0,width);
          float my = map(ry,-1,1,0,height);
          float ncx = constrain(mx,0,width);
          float ncy = constrain(my,0,height);
          seed1.update(ncx,ncy);
          //cx = (cx+ncx)/2;
          //cy = (cy+ncy)/2;
          println("Controller 1: "+seed1.down+" X:"+ncx+" Y:"+ncy);
        }else{
          //Controller 2:
          if(data[1].equals("0")){
            if(!seed2.down){
              brush2.startStroke();
            }
            seed2.down = true;
          }else{
            if(seed2.down){
              brush2.endStroke();
            }
            seed2.down = false;
          }
          float rx = Float.parseFloat(data[2]);
          float ry = Float.parseFloat(data[3]);
          float mx = map(rx,-1,1,0,width);
          float my = map(ry,-1,1,0,height);
          float ncx = constrain(mx,0,width);
          float ncy = constrain(my,0,height);
          seed2.update(ncx,ncy);
          //cx = (cx+ncx)/2;
          //cy = (cy+ncy)/2;
          println("Controller 2: "+seed2.down+" X:"+ncx+" Y:"+ncy);
          
        }
      } catch (Exception e){
        println(s);
      }
     }
  }
}

 


