import java.util.Map;

//Must always use the name 'controller' for the GameInput so that keyPressed and Released function work properly

class GameInput {
  HashMap<String,Integer> downKeys = new HashMap<String,Integer>();
  HashMap<String,Integer> hitKeys = new HashMap<String,Integer>();
  ArrayList<String> keysToProcess;
  
  GameInput(){
    initMap(downKeys);
    initMap(hitKeys);
  }
  
  void initMap(HashMap map){
    map.put("a",0);
    map.put("b",0);
    map.put("c",0);
    map.put("d",0);
    map.put("e",0);
    map.put("f",0);
    map.put("g",0);
    map.put("h",0);
    map.put("i",0);
    map.put("j",0);
    map.put("k",0);
    map.put("l",0);
    map.put("m",0);
    map.put("n",0);
    map.put("o",0);
    map.put("p",0);
    map.put("q",0);
    map.put("r",0);
    map.put("s",0);
    map.put("t",0);
    map.put("u",0);
    map.put("v",0);
    map.put("w",0);
    map.put("x",0);
    map.put("y",0);
    map.put("z",0);
    map.put("1",0);
    map.put("2",0);
    map.put("3",0);
    map.put("4",0);
    map.put("5",0);
    map.put("6",0);
    map.put("7",0);
    map.put("8",0);
    map.put("9",0);
    map.put("0",0);
    map.put("left",0);
    map.put("right",0);
    map.put("up",0);
    map.put("down",0);
    map.put("space",0);
  }
  
  void setPressed(String input){
    downKeys.put(input,1);
  }
  void setReleased(String input){
    downKeys.put(input,0);
    hitKeys.put(input,1);
  }
  
  ArrayList<String> getHitKeys(){
    keysToProcess = new ArrayList<String>();
    for (Map.Entry e : hitKeys.entrySet()){
      if((Integer)e.getValue()==1){
        keysToProcess.add((String)e.getKey());
      }
    }
    initMap(hitKeys);
    return keysToProcess;
  }
  
  boolean keyDown(String input){
    if(downKeys.get(input)==1){
      return true;
    }else{
      return false;
    }
  }
}

void keyPressed(){
  if(key==CODED){
    String input = "";
    switch(keyCode){
      case UP:
        input = "up";
        break;
      case DOWN:
        input = "down";
        break;
      case LEFT:
        input = "left";
        break;
      case RIGHT:
        input = "right";
        break;
    }
    if(input!=""){
      controller.setPressed(input);
    }
  }else if(key==' '){
    controller.setPressed("space");
  }else{
    controller.setPressed(str(key));
  }
}

void keyReleased(){
  if(key==CODED){
    String input = "";
    switch(keyCode){
      case UP:
        input = "up";
        break;
      case DOWN:
        input = "down";
        break;
      case LEFT:
        input = "left";
        break;
      case RIGHT:
        input = "right";
        break;
    }
    if(input!=""){
      controller.setReleased(input);
    }
  }else if(key==' '){
    controller.setReleased("space");
  }else{
    controller.setReleased(str(key));
  }
}
