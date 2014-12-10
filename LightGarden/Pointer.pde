class Pointer {
  float x,y,prevX,prevY,xShift,yShift,xConstrain,yConstrain,newX,newY,xSum,ySum;
  boolean down;
  
  float changeSpeed = 45;
  float smoothing = 2;
  Pointer(){
    x = width/2;
    y = width/2;
    down = false;
  }
  
  void update(float xChange, float yChange){
    prevX = x;
    prevY = y;
    xShift = map(xChange, -1,1,-changeSpeed,changeSpeed);
    yShift = map(yChange, -1,1,-changeSpeed,changeSpeed);
    newX = prevX+xShift;
    newY = prevY+yShift;
    xConstrain = constrain(newX,0,width);
    yConstrain = constrain(newY,0,height);
    xSum = xConstrain;
    ySum = yConstrain;
    for(int i=1;i<smoothing;i++){
      xSum+=prevX;
      ySum+=prevY;
    }
    x = xSum/smoothing;
    y = ySum/smoothing;
  }
  
  void simpleUpdate(float xPos, float yPos){
    x = xPos;
    y = yPos;
  }
}
