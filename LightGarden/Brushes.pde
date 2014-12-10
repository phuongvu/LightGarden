class StarburstBrush extends LightBrush {
  
  int dotWidth = 5;
  
  StarburstBrush(Pointer seed){
    super(seed);
    brushName = "Starburst";
    brushColor = 185;
    //strokeGraphic = createShape(ELLIPSE,-dotWidth/2,-dotWidth/2,dotWidth,dotWidth);
    //strokeGraphic.disableStyle();
    //maxSpeed = 4;
    sym = 6;
  }
  
  @Override PGraphics drawFrame(ArrayList<RPoint> markers,PGraphics layer){
    layer.beginDraw();
    layer.noStroke();
    layer.smooth(2);
    RPoint p1 = markers.get(0);
    float markerSize = 2+p1.dist/520;//1/(340/(340/2+p.dist));
    float offset = p1.dist/12;
    float brg = map(p1.dist,0,width,255,0);
    float sat = map(p1.dist,0,height-700,0,255);
    
    setColor(layer,sat,brg,starOpacity);
    for (RPoint p : markers){
      
      layer.ellipse(p.x,p.y,markerSize*1.4,markerSize*1.4);
      /*layer.pushMatrix();
      layer.translate(p.x,p.y);
      strokeGraphic.scale(markerSize);
      strokeGraphic.scale(1.1);
      layer.shape(strokeGraphic);
      layer.popMatrix();
      strokeGraphic.resetMatrix();
      strokeGraphic.scale(markerSize);*/
      float ox = p.x + cos(p.rot)*offset;
      float oy = p.y + sin(p.rot)*offset;
      ArrayList<RPoint> bursts = getRadialSymmetry(3,ox,oy,p.x,p.y);
      for (RPoint b: bursts){
        /*layer.pushMatrix();
        layer.translate(b.x,b.y);
        layer.shape(strokeGraphic);
        layer.popMatrix();*/
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
    brushColor = 222;
    //maxSpeed = 5;
    sym = 8;
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

class StarfieldBrush extends SmoothBrush {
  
  StarfieldBrush(Pointer seed){
    super(seed);
    brushName = "Starfield";
    brushColor = 155;
    maxSpeed = 8;
    sym = 7;
    bilateralSym = false;
  }
  
  @Override PGraphics drawFrame(ArrayList<RPoint> markers,PGraphics layer){
    layer.beginDraw();
    layer.noStroke();
    layer.smooth(2);
    RPoint p1 = markers.get(0);
    float markerSize = 2+p1.dist/340;//1/(340/(340/2+p.dist));
    //float offset = p1.dist/24;
    float brg = map(p1.dist,0,width-600,255,0);
    float sat = map(p1.dist,0,height-400,0,255);
    
    setColor(layer,sat,brg,starOpacity);
    for (RPoint p : markers){
      float numPoints = p.dist/80;
      float spread = 16;
      setColor(layer,sat,brg,starOpacity);
      layer.ellipse(p.x,p.y,markerSize,markerSize);
      for (int i=0;i<numPoints;i++){
        float rx = random(p.dist/spread)-(p.dist/spread)/2;
        float ry = random(p.dist/spread)-(p.dist/spread)/2;
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
    brushColor = 267;
    sym = 3;
  }
  
  @Override PGraphics drawFrame(ArrayList<RPoint> markers, PGraphics layer){
    layer.beginDraw();
    layer.noFill();
    //setColor(layer,50);
    layer.stroke(color(brushColor,204,215,threadOpacity));
    layer.strokeWeight(0.8);
    ArrayList<RPoint> startPoints = getRadialSymmetry(sym,strokeX,strokeY,centerX,centerY);
    //ArrayList<RPoint> lastPoints = getRadialSymmetry(sym,lastX,lastY,centerX,centerY);
    //ArrayList<RPoint> prevPoints = getRadialSymmetry(sym,endX,endY,centerX,centerY);
    float noiseX = random(noiseScale)-noiseScale/2;
    float noiseY = random(noiseScale)-noiseScale/2;
    for (RPoint p: markers){
      //RPoint last = lastPoints.get(markers.indexOf(p));
      RPoint start = startPoints.get(markers.indexOf(p));
      //RPoint prev = prevPoints.get(markers.indexOf(p));
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
