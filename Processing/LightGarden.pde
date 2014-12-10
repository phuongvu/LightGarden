import processing.serial.*;
import beads.*;

public void init() { //For removing window border
  frame.removeNotify(); 
  frame.setUndecorated(true); 
  frame.addNotify(); 
  super.init();
}

Serial port;
NoiseCurve curve;
color c;
boolean presentMode = false;
String mode = "curve";
float curveOpacity = 34;
float starOpacity = 135;
float threadOpacity = 18;
GameInput controller;

color hues[] = {207,222,268,152};

boolean useController = false;
float cx, cy, centerX, centerY;

LightBrush currentBrush, starfieldBrush, starburstBrush, convergeBrush, squiggleBrush;
LightBrush brush1, brush2;
ArrayList<LightBrush> brushes;
int brushIndex = 0;
int timeOff = 0;
int timeToLogo = 12000;

Pointer seed1, seed2;

LightSeed user, user1, user2;

AudioContext ac;
Sound sound1, sound2;

PImage logo;

void setup() {
  //size(2560,720,P2D);
  size(1440,900,P2D);
  //frame.setLocation(1435,0);
  frame.setLocation(0,0);
  controller = new GameInput();
  
  colorMode(HSB,360,255,255,255);
  
  noStroke();
  noCursor();
  frameRate(30);
  background(0);
  
  centerX = width/2;
  centerY = height/2;
  
  seed1 = new Pointer();
  seed2 = new Pointer();
  
  user1 = new LightSeed(seed1);
  user2 = new LightSeed(seed2);
  
  //User 1 brushes
  starburstBrush = new StarburstBrush(seed1);
  convergeBrush = new ConvergeBrush(seed1);
  user1.assignBrush(convergeBrush);
  user1.assignBrush(starburstBrush);
  
  if(useController){
    //User 2 brushes;
    squiggleBrush = new SquiggleBrush(seed2);
    starfieldBrush = new StarfieldBrush(seed2);
    user2.assignBrush(starfieldBrush);
    user2.assignBrush(squiggleBrush);
  }else{
    squiggleBrush = new SquiggleBrush(seed1);
    starfieldBrush = new StarfieldBrush(seed1);
    user1.assignBrush(starfieldBrush);
    user1.assignBrush(squiggleBrush);
  }
  
  println(Serial.list());
  if(useController){
    port = new Serial(this, Serial.list()[5], 9600); 
  }
  
  ac = new AudioContext();

  String ambient = sketchPath("") + "sounds/Loop_mixdown.wav";
  String windChime = sketchPath("") + "sounds/chime.wav";

  //sound1 = new Sound(ambient, 0.9, ac);
  sound2 = new Sound(windChime, 0.0, ac);

  //ac.out.addInput(sound1.getGain());
  ac.out.addInput(sound2.getGain());

  ac.start();
  
  logo = loadImage("Logo.png");
}
 
void draw() { 
  checkInput();
  background(0);
  
  if(!useController){seed1.simpleUpdate(mouseX,mouseY);}
  
  if(useController){
    if(user1.currentBrush.brushDown || user2.currentBrush.brushDown){
      if(presentMode){
        user1.seed.simpleUpdate(centerX,centerY);
        user2.seed.simpleUpdate(centerX,centerY);
        user1.fadeOut();
        user2.fadeOut();
      }
      presentMode = false;
      timeOff = millis();
    }else if(millis()-timeOff>timeToLogo){
      presentMode = true;
    }
  }else if(presentMode && user1.currentBrush.brushDown){
    presentMode = false;
  }
  
  user1.update();
  if(useController){user2.update();}
  
  image(user1.drawing,0,0);
  if(useController){image(user2.drawing,0,0);}
  
  if(!presentMode){
    image(user1.overlay,0,0);
    if(useController){image(user2.overlay,0,0);}
  }else if(useController){
    image(logo,500,height/2-40,680,160);
  }
  
}

void checkInput(){
  ArrayList<String> hitKeys = controller.getHitKeys();
  for (String k : hitKeys){
    if (k.equals("1")||k.equals("2")||k.equals("3")||k.equals("4")||k.equals("5")||k.equals("6")||k.equals("7")||k.equals("8")||k.equals("9")){
      user1.currentBrush.sym = Integer.parseInt(k);
    }else if (k.equals("c")){
      user1.fadeOut();
    }else if (k.equals("b")){
      user1.cycleBrush();
    }else if (k.equals("f")){
      user1.currentBrush.bilateralSym = !user1.currentBrush.bilateralSym;
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
  if(!useController){
    user1.currentBrush.startStroke();
  }
}

void mouseReleased(){
  if(!useController){
    user1.currentBrush.endStroke();
  }
}

void serialEvent(Serial myPort) { 
  if(useController){
     String s = myPort.readStringUntil('\n');
     if(s!=null&&s.charAt(0)=='<'){
       s = s.substring(1,s.length()-3);
      try {
        String data[] = split(s,",");
        println(data);
        Pointer seed = null;
        LightBrush brush = null;
        if(data[0].equals("0")){
          //Controller 1:
          user = user1;
          seed = user1.seed;
          brush = user1.currentBrush;
        }else{
          //Controller 2:
          user = user2;
          seed = user2.seed;
          brush = user2.currentBrush;
        }
        float brushMode = Float.parseFloat(data[1]);
        if(brushMode==2){
          user.fadeOut();
        }else if(user.brushIndex!=brushMode){
          user.cycleBrush();
        }
        if(data[2].equals("0")){
          if(!seed.down){
            brush.startStroke();
          }
          seed.down = true;
        }else if(data[2].equals("1")){
          if(seed.down){
            brush.endStroke();
          }
          seed.down = false;
        }
        float rx = Float.parseFloat(data[3]);
        float ry = Float.parseFloat(data[4]);
        /*float mx = map(rx,-1,1,0,width);
        float my = map(ry,-1,1,0,height);
        float ncx = constrain(mx,0,width);
        float ncy = constrain(my,0,height);
        cx = (seed.x+ncx)/2;
        cy = (seed.y+ncy)/2;*/
        seed.update(rx,ry);
        if(data[0].equals("0")){
          print("Controller 1: ");
        }else{
          print("Controller 2: ");
        }
        println(seed.down+" X:"+rx+" Y:"+ry);
      } catch (Exception e){
        println("Data failed to process - Raw string: "+s);
      }
     }
  }
}

 


