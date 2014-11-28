class RadSymPoint {
  float x;
  float y;
  float rot;
  
  RadSymPoint(float x, float y, float rot){
    this.x = x;
    this.y = y;
    this.rot = rot;
  }
}

ArrayList<RadSymPoint> getRadialSymmetry(int sym){
  ArrayList<RadSymPoint> markers = new ArrayList<RadSymPoint>();
  
  float dx = mouseX-width/2;
  float dy = mouseY-height/2;
  float dist = (float)sqrt(sq(dx)+sq(dy));
  float ang = atan2(dy,dx);
  markers.add(new RadSymPoint(mouseX,mouseY,ang));
  
  float shift = (2*PI)/sym;
  for(int i=1;i<sym;i++){
    ang+=shift;
    float x = width/2+cos(ang)*dist;
    float y = height/2+sin(ang)*dist;
    markers.add(new RadSymPoint(x,y,ang));
  }
  return markers;
}
