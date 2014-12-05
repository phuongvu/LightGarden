class Pointer {
  float x, y;
  Pointer(){
    x = width/2;
    y = width/2;
  }
  
  void update(float xPos, float yPos){
    x = xPos;
    y = yPos;
  }
}
