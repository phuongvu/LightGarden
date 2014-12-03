class StarburstBrush extends LightBrush {
  
  StarburstBrush(){
    super();
    brushName = "Starburst";
  }
  
  @Override PGraphics drawFrame(ArrayList<RPoint> markers,PGraphics layer){
    layer.beginDraw();
    layer.noStroke();
    layer.smooth(2);
    setColor(layer,starOpacity);
    for (RPoint p : markers){
      float markerSize = 2+p.dist/340;
      float offset = p.dist/12;
      
      layer.ellipse(p.x,p.y,markerSize*1.4,markerSize*1.4);
      float ox = p.x + cos(p.rot)*offset;
      float oy = p.y + sin(p.rot)*offset;
      ArrayList<RPoint> bursts = getRadialSymmetry(sym,ox,oy,p.x,p.y);
      for (RPoint b: bursts){
        layer.ellipse(b.x,b.y,markerSize,markerSize);
      }
    }
    layer.endDraw();
    return layer;
  }
  
}

class ConvergeBrush extends LightBrush {
  
  ConvergeBrush(){
    super();
    brushName = "Converge";
  }
  
  @Override PGraphics drawFrame(ArrayList<RPoint> markers,PGraphics layer){
    layer.beginDraw();
    layer.noStroke();
    for (RPoint p : markers){
      curve = new NoiseCurve(p.dist/2+random(p.dist/2)+8,p);
      c = setColor(layer,curveOpacity);
      curve.drawCurve(c,layer);
    }
    layer.endDraw();
    return layer;
  }
  
}

class StarfieldBrush extends LightBrush {
  
  StarfieldBrush(){
    super();
    brushName = "Starfield";
  }
  
  @Override PGraphics drawFrame(ArrayList<RPoint> markers,PGraphics layer){
    layer.beginDraw();
    layer.noStroke();
    layer.smooth(2);
    for (RPoint p : markers){
      float markerSize = 2+p.dist/340;
      float numPoints = p.dist/60;
      float spread = 9;
      float brightness = constrain(240-(p.dist/4),60,255);
      setColor(layer,brightness,starOpacity);
      layer.ellipse(p.x,p.y,markerSize,markerSize);
      for (int i=0;i<numPoints;i++){
        float rx = random(p.dist/spread)-(p.dist/spread)/2;
        float ry = random(p.dist/spread)-(p.dist/spread)/2;
        setColor(layer,brightness,starOpacity);
        layer.ellipse(p.x+rx,p.y+ry,markerSize,markerSize);
      }
    }
    layer.endDraw();
    return layer;
  }
}
