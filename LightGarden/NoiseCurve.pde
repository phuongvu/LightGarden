class NoiseCurve {
  ArrayList<Point> points;
  int numPoints;
  float xPos;
  float yPos;
  float rotation = 0;
  int pointSize = 8;
  color black = color(0,0,0,0.2);
  
  NoiseCurve(int size,float x, float y, float rotation){
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
  
  NoiseCurve(int size, RadSymPoint marker){
    this(size,marker.x,marker.y,marker.rot);
  }
  
  void drawCurve(color c){
    float noise = 0;
    
    for (Point p: points){
      fill(c);
      float dx = p.x-xPos;
      float dy = yPos-p.y;
      float dist = (float)Math.sqrt(sq(dx)+sq(dy));
      float ang = atan2(dy,dx);
      float newAng = ang+rotation;
      float nx = xPos+cos(newAng)*dist;
      float ny = yPos+sin(newAng)*dist;
      ellipse(nx,ny,pointSize,pointSize);
    }
  }
  
}
