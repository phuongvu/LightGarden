class Pointer {
  float x, y;
  boolean down;
  Pointer(){
    x = width/2;
    y = width/2;
    down = false;
  }
  
  void update(float xPos, float yPos){
    x = xPos;
    y = yPos;
  }
}
