class LightSeed {
  //Class for wireless controllers
  //Stores 'seed' pointer objects, brushes, colors, and states
  
  Pointer seed;
  PGraphics drawing;
  PGraphics overlay;
  PGraphics mask;
  ArrayList<LightBrush> brushes;
  LightBrush currentBrush;
  int brushIndex;
  
  boolean fading = false;
  float fade = 0;
  float frames = 0;
  float fadeRate = 40;
  
  LightSeed(Pointer seed){
    this.seed = seed;
    brushes = new ArrayList<LightBrush>();
    brushIndex = 0;
    drawing = createGraphics(width,height);
    overlay = createGraphics(width,height);
    mask = createGraphics(width,height);
  }
  
  void assignBrush(LightBrush newBrush){
    brushes.add(newBrush);
    if(brushes.size()==1){
      currentBrush = newBrush;
    }
  }
  
  void cycleBrush(){
    brushIndex++;
    if(brushIndex>brushes.size()-1){
      brushIndex = 0;
    }
    currentBrush = brushes.get(brushIndex);
  }
  
  PGraphics update(){
    currentBrush.update(drawing,overlay);
    /*if(fading){
      frames++;
      if(frames>fadeRate){
        fading = false;
        frames = 0;
        drawing.clear();
        mask.beginDraw();
        mask.background(255);
        mask.endDraw();
        drawing.mask(mask);
        
      }else{
        fade = 255-(255*(frames/fadeRate));
        println(fade);
        mask.beginDraw();
        mask.background(255,fade);
        mask.endDraw();
        drawing.mask(mask);
      }
    }*/
    return drawing;
  }
  
  void fadeOut(){
    fading = true;
    drawing.beginDraw();
    drawing.clear();
    drawing.endDraw();
  }
}
