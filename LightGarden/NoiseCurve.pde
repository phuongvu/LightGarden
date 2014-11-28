class NoiseCurve {
  ArrayList<Point> points;
  float numPoints;
  float xPos;
  float yPos;
  float rotation = 0;
  float pointSize = 9;
  
  NoiseCurve(float size,float x, float y, float rotation){
    xPos = x;
    yPos = y;
    points = new ArrayList<Point>();
    numPoints = size;
    this.rotation = rotation;
    float noise = 0;
    for (int i=0;i<numPoints;i++){
      noise += (float)((Math.random()*8)-4);
      Point p = new Point(xPos+i,yPos+noise);
      points.add(p);
    }
  }
  
  NoiseCurve(float size, RPoint marker){
    this(size,marker.x,marker.y,marker.rot);
  }
  
  void drawCurve(color c, PGraphics canvas){
    float noise = 0;
    for (Point p: points){
      canvas.fill(c);
      float dx = p.x-xPos;
      float dy = yPos-p.y;
      float dist = (float)Math.sqrt(sq(dx)+sq(dy));
      float ang = atan2(dy,dx);
      float newAng = ang+rotation;
      float nx = xPos+cos(newAng)*dist;
      float ny = yPos+sin(newAng)*dist;
      canvas.ellipse(nx,ny,pointSize,pointSize);
    }
  }
  
}
