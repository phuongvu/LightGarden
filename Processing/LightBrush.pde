class LightBrush {
  //Base class for all brushes
  //Each brush will have its own initialization, draw method, and necessary configuration functions
  //Ideally nearly everything else will be handled here
  //Some sub-classes may be added for brushes which use radically different smoothing or input types
  
  int strokeWidth; //Stroke settings
  color strokeColor;
  
  int brushColor; //Brush fill settings
  int hueJitter;
  int brightnessJitter;
  
  float centerX,centerY; //Symmetry center point
  
  float xPos,yPos; //Current brush position
  
  float strokeX,strokeY; //Location where the current stroke started
  int strokeStart; //Millis when stroke started
  int timeDown; //Millis since stroke started
  int lastStroke; //Millis when last stroke ended;
  float endX, endY; //Location where the last stroke ended
  float lastX,lastY; //Location on last frame
  
  PShape strokeGraphic;
  PShape markerShape; //could be PImage or PGraphics instead if necessary
  float markerWidth, markerHeight; //For proper positioning of marker points;
  String brushName; //Uniquely identifies each type of brush
  boolean brushDown; //Whether or not the brush is currently drawing
  
  float mainMarkerOpacity = 160;
  float markerOpacity = 40;
  
  boolean bilateralSym;
  int sym;
  
  PGraphics dLayer; //The overall drawing layer
  PGraphics oLayer; //The marker overlay layer
  
  Pointer seed; //An object which tracks the position of the pointing device (mouse or seed controller)
  
  LightBrush(Pointer pointer){ //Should be just basic initialization and default config
    brushDown = false;
    brushName = "Default";
    bilateralSym = true;
    sym = 5;
    centerX = width/2;
    centerY = height/2;
    xPos = centerX;
    yPos = centerY;
    lastX = xPos;
    lastY = yPos;
    endX = xPos;
    endY = yPos;
    dLayer = createGraphics(width,height);
    oLayer = createGraphics(width,height);
    
    dLayer.beginDraw();
    dLayer.background(0);
    dLayer.endDraw();
    seed = pointer;
    
    /*PShape circle = createShape(ELLIPSE,0,0,20,20);
    circle.disableStyle();
    markerShape = circle;*/
    markerWidth = markerHeight = 20;
  }
  
  PGraphics drawFrame(ArrayList<RPoint> markers,PGraphics layer){ //Called from main script when brush is down; //Could pass marker positions, or have each brush generate them based on parameters
    return layer;
  }
  
  PGraphics drawMarkers(ArrayList<RPoint> markers,PGraphics layer,float mainScale,float scale){ //Draw appropriate markers based on brush color and whether or not it's currently being drawn with
    layer.beginDraw();
    layer.noStroke();
    layer.clear();
    markers = getRadialSymmetry(sym,seed.x,seed.y,centerX,centerY);
    float markerSize = mainScale*markerWidth;
    setColor(layer,mainMarkerOpacity);
    for (RPoint p : markers){
      
      layer.ellipse(p.x,p.y,markerSize,markerSize);
      layer.fill(255,0,255,markerOpacity);
      markerSize = scale*markerWidth;
    }
    layer.endDraw();
    return layer;
  }
  
  void setBrushColor(color brushColor){
    this.brushColor = brushColor;
  }
  
  void setBrushColor(color brushColor, int hueJitter, int brightnessJitter){
    this.brushColor = brushColor;
    this.hueJitter = hueJitter;
    this.brightnessJitter = brightnessJitter;
  }
  
  void updatePosition(){ //Simplest implementation of updating brush position from pointer, override for more complex smoothing/lagging etc
    lastX = xPos;
    lastY = yPos;
    xPos = seed.x;
    yPos = seed.y;
  }
  
  void updateTime(){
    timeDown = millis()-strokeStart;
  }
  
  void setSymOrigin(float x, float y){ //Set origin for radial symmetry, could be fixed to center, or based on the point where the stroke started
    centerX = x;
    centerY = y;
  }
  
  void startStroke(){
    brushDown = true;
    updatePosition();
    strokeX = xPos;
    strokeY = yPos;
    strokeStart = millis();
    
    sound2.setPlayerPosition((double)random(2000));
    sound2.setEnvelope(0.5, 500);
    
  }
  
  void endStroke(){
    endX = xPos;
    endY = yPos;
    brushDown = false;
    lastStroke = millis();
    
    sound2.setEnvelope(0.5, 200);
    sound2.setEnvelope(0.3, 400);
    sound2.setEnvelope(0.1, 600);
    sound2.setEnvelope(0.0, 800);
  }
  
  void drawFlipped(PGraphics layer, PGraphics image){
    layer.pushMatrix();
    layer.scale(-1,1);
    layer.translate(-width,0);
    layer.image(image,0,0);
    layer.popMatrix();
  }
  
  PGraphics update(PGraphics layer,PGraphics overlay){ //Ideally, this logic should never need to be overridden, only the drawFrame and drawMarker methods would change
    updatePosition(); //Update current brush position from pointer
    ArrayList<RPoint> markers = getRadialSymmetry(sym,xPos,yPos,centerX,centerY); //Generate radial symmetry for this frame
    overlay.clear();
    if(brushDown){
      updateTime();
      layer.beginDraw();
      dLayer.clear();
      drawFrame(markers,dLayer);
      layer.image(dLayer,0,0);
      if(bilateralSym){
        drawFlipped(layer,dLayer);
      }
      layer.endDraw();
    }
    
    overlay.beginDraw();
    oLayer.clear();
    if(brushDown){
      drawMarkers(markers,oLayer,0.9,0.25);
    }else{
      drawMarkers(markers,oLayer,1.0,0.3);
    }
    overlay.image(oLayer,0,0);
    if(bilateralSym){
      if(brushDown){
        drawMarkers(markers,oLayer,0.3,0.25);
      }else{
        drawMarkers(markers,oLayer,0.3,0.3);
      }
      drawFlipped(overlay,oLayer);
    }
    overlay.endDraw();
    return layer;
  }
  
  color setColor(PGraphics layer, float opacity){
    int hue = brushColor;
    layer.colorMode(HSB,360,255,255,255);
    c = color(hue,255,178,opacity);
    layer.fill(c);
    return c;
  }
  
  color setColor(PGraphics layer, float brightness, float opacity){
    int hue = brushColor;
    layer.colorMode(HSB,360,255,255,255);
    c = color(hue,255,brightness,opacity);
    layer.fill(c);
    return c;
  }
  color setColor(PGraphics layer, float saturation, float brightness, float opacity){
    int hue = brushColor;
    layer.colorMode(HSB,360,255,255,255);
    c = color(hue,saturation,brightness,opacity);
    layer.fill(c);
    return c;
  }
}

class SmoothBrush extends LightBrush {
  
  float maxSpeed = 5;
  
  SmoothBrush(Pointer pointer){
    super(pointer);
  }
  
  @Override void updatePosition(){
    if(brushDown){
      float dx = seed.x - xPos;
      float dy = seed.y - yPos;
      float speed = (float)sqrt(sq(dx)+sq(dy));
      if(speed>maxSpeed){
        dx = (dx/speed)*maxSpeed; 
        dy = (dy/speed)*maxSpeed;
      }
      lastX = xPos;
      lastY = yPos;
      xPos += dx;
      yPos += dy;
    }else{
      super.updatePosition();
    }
  }
}
