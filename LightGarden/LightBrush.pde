class LightBrush {
  //Base class for all brushes
  //Each brush will have its own initialization, draw method, and necessary configuration functions
  //Ideally nearly everything else will be handled here
  //Some sub-classes may be added for brushes which use radically different smoothing or input types
  
  int strokeWidth; //Stroke settings
  color strokeColor;
  
  color brushColor; //Brush fill settings
  int hueJitter;
  int brightnessJitter;
  
  float centerX,centerY; //Symmetry center point
  
  float xPos,yPos; //Current brush position
  
  float strokeX,strokeY; //Location where the current stroke started
  
  PShape markerShape; //could be PImage or PGraphics instead if necessary
  String brushName; //Uniquely identifies each type of brush
  boolean brushDown; //Whether or not the brush is currently drawing
  
  boolean bilateralSym;
  int sym;
  
  PGraphics dLayer; //The overall drawing layer
  PGraphics oLayer; //The marker overlay layer
  
  LightBrush(){ //Should be just basic initialization and default config
    brushDown = false;
    brushName = "Default";
    bilateralSym = true;
    sym = 3;
    centerX = width/2;
    centerY = height/2;
    xPos = centerX;
    yPos = centerY;
    dLayer = createGraphics(width,height);
    oLayer = createGraphics(width,height);
    
    dLayer.beginDraw();
    dLayer.background(0);
    dLayer.endDraw();
  }
  
  PGraphics drawFrame(ArrayList<RPoint> markers,PGraphics layer){ //Called from main script when brush is down; //Could pass marker positions, or have each brush generate them based on parameters
    return layer;
  }
  
  PGraphics drawMarkers(ArrayList<RPoint> markers,PGraphics layer,int mainScale,int scale){ //Draw appropriate markers based on brush color and whether or not it's currently being drawn with
    layer.beginDraw();
    layer.noStroke();
    layer.clear();
    float markerSize = mainScale;
    setColor(layer,120);
    for (RPoint p : markers){
      layer.ellipse(p.x,p.y,markerSize,markerSize);
      layer.fill(255,0,255,40);
      markerSize = scale;
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
  
  void updatePosition(float x, float y){ //Simplest implementation of updating brush position, override for more complex smoothing/lagging etc
    xPos = x;
    yPos = y;
  }
  
  void setSymOrigin(float x, float y){ //Set origin for radial symmetry, could be fixed to center, or based on the point where the stroke started
    centerX = x;
    centerY = y;
  }
  
  void startStroke(float x, float y){
    brushDown = true;
    strokeX = x;
    strokeY = y;
    updatePosition(x,y);
  }
  
  void endStroke(){
    brushDown = false;
  }
  
  void drawFlipped(PGraphics layer, PGraphics image){
    layer.pushMatrix();
    layer.scale(-1,1);
    layer.translate(-width,0);
    layer.image(image,0,0);
    layer.popMatrix();
  }
  
  PGraphics update(PGraphics layer,PGraphics overlay,float x, float y){ //Ideally, this logic should never need to be overridden, only the drawFrame and drawMarker methods would change
    updatePosition(x,y);
    ArrayList<RPoint> markers = getRadialSymmetry(sym,xPos,yPos,centerX,centerY);
    overlay.clear();
    if(brushDown){
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
      drawMarkers(markers,oLayer,12,5);
    }else{
      drawMarkers(markers,oLayer,20,10);
    }
    overlay.image(oLayer,0,0);
    if(bilateralSym){
      if(brushDown){
        drawMarkers(markers,oLayer,8,5);
      }else{
        drawMarkers(markers,oLayer,12,10);
      }
      drawFlipped(overlay,oLayer);
    }
    overlay.endDraw();
    return layer;
  }
}
