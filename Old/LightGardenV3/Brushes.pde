class StarburstBrush extends LightBrush {
  
  StarburstBrush(Pointer seed){
    super(seed);
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
  
  ConvergeBrush(Pointer seed){
    super(seed);
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
  
  StarfieldBrush(Pointer seed){
    super(seed);
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

class SquiggleBrush extends LightBrush {
  
  float noiseScale = 60;
  
  SquiggleBrush(Pointer seed){
    super(seed);
    brushName = "Squiggle";
  }
  
  @Override PGraphics drawFrame(ArrayList<RPoint> markers, PGraphics layer){
    layer.beginDraw();
    layer.noFill();
    //setColor(layer,50);
    layer.stroke(color(currentHue(),255,255,threadOpacity));
    layer.strokeWeight(0.8);
    ArrayList<RPoint> startPoints = getRadialSymmetry(sym,strokeX,strokeY,centerX,centerY);
    ArrayList<RPoint> lastPoints = getRadialSymmetry(sym,lastX,lastY,centerX,centerY);
    ArrayList<RPoint> prevPoints = getRadialSymmetry(sym,endX,endY,centerX,centerY);
    float noiseX = random(noiseScale)-noiseScale/2;
    float noiseY = random(noiseScale)-noiseScale/2;
    for (RPoint p: markers){
      RPoint last = lastPoints.get(markers.indexOf(p));
      RPoint start = startPoints.get(markers.indexOf(p));
      RPoint prev = prevPoints.get(markers.indexOf(p));
      ArrayList<RPoint> burst = getRadialSymmetry(9,p.x,p.y,start.x,start.y);
      for (RPoint b : burst){
        layer.beginShape();
        //layer.vertex(b.x+noiseX,b.y+noiseY);
        //layer.quadraticVertex(last.x,last.y,p.x,p.y);
        layer.vertex(b.x,b.y);
        layer.quadraticVertex(start.x+noiseX,start.y+noiseY,p.x,p.y);
        layer.endShape();
      }
      //layer.line(last.x,last.y,p.x,p.y);
    }
    layer.endDraw();
    return layer;
  }
}
