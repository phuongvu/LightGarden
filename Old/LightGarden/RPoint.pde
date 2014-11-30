class RPoint {
  float x;
  float y;
  float rot;
  float dist;
  
  RPoint(float x, float y, float rot, float dist){
    this.x = x;
    this.y = y;
    this.rot = rot;
    this.dist = dist;
  }
}

ArrayList<RPoint> getRadialSymmetry(int sym){
  ArrayList<RPoint> markers = new ArrayList<RPoint>();
  
  float dx = mouseX-width/2;
  float dy = mouseY-height/2;
  float dist = (float)sqrt(sq(dx)+sq(dy));
  float ang = atan2(dy,dx);
  markers.add(new RPoint(mouseX,mouseY,ang,dist));
  
  float shift = (2*PI)/sym;
  for(int i=1;i<sym;i++){
    ang+=shift;
    float x = width/2+cos(ang)*dist;
    float y = height/2+sin(ang)*dist;
    markers.add(new RPoint(x,y,ang,dist));
  }
  return markers;
}
