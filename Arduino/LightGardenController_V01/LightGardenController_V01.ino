//Light Garden Controller 1 Code, 2014

#include <Wire.h> 
#include <SFE_MMA8452Q.h> 

MMA8452Q accel;

long time=0;
long leftBtnLastTime = 0;
long rightBtnLastTime = 0;
long timeElapsed =0;
long dualBtnHoldTime = 0;
boolean timerStart = false;
long dualBtnHoldTimeDelay = 1500;
boolean reset = false;
int btnReadDelay = 200;

int redLEDPin = 9;
int greenLEDPin = 10;
int blueLEDPin = 11;

int leftBtn = 12;
int rightBtn = 2;

int leftBtnVal= 0;
int rightBtnVal =0;

boolean currentLEDColor = false;

void setup(){
  Serial.begin(9600);
  Serial.println("CtrlON");
  accel.init();

  pinMode(redLEDPin, OUTPUT);
  pinMode(greenLEDPin, OUTPUT);
  pinMode(blueLEDPin, OUTPUT);

  pinMode(leftBtn,INPUT_PULLUP);
  pinMode(rightBtn,INPUT_PULLUP);

  digitalWrite(greenLEDPin, HIGH);
  delay(500);
  digitalWrite(greenLEDPin, LOW);


}


void loop(){



  leftBtnVal = digitalRead(leftBtn);
  rightBtnVal = digitalRead(rightBtn);

  if (millis() - leftBtnLastTime >= btnReadDelay){
    if (leftBtnVal == false){
      currentLEDColor = !currentLEDColor;
      leftBtnLastTime = millis();
    } 
  }



  if ((leftBtnVal == 0) && (rightBtnVal == 0) && (timerStart == false)){
    timerStart = true;
    dualBtnHoldTime = millis();

  }

  else 

    if (timerStart == true){
    timeElapsed = millis() - dualBtnHoldTime ;
    if (timeElapsed >=  dualBtnHoldTimeDelay){

      reset = true; 
    }

    if ((leftBtnVal == 1 || rightBtnVal == 1)){
      timerStart = false;
      dualBtnHoldTime = 0;

      reset = false;

    }

  }







  if (currentLEDColor == false){
    analogWrite(blueLEDPin, 250);
    analogWrite(greenLEDPin, 0);
    analogWrite(redLEDPin,0); 

  }
  else
    if (currentLEDColor == true){
      analogWrite(blueLEDPin, 250);
      analogWrite(greenLEDPin, 250);
      analogWrite(redLEDPin,0);
    }

  delay(50); //150


    if (accel.available()){


    accel.read();




    printCalculatedAccels();


  }
  else
    digitalWrite(blueLEDPin, LOW);


}






void printCalculatedAccels()
{ 
  Serial.print("<");
  Serial.print("0");
  Serial.print(",");
  if(reset){
    Serial.print("2");
  }
  else if(currentLEDColor){
    Serial.print("1");
  }
  else{
    Serial.print("0");
  }
  Serial.print(",");
  Serial.print(rightBtnVal);
  Serial.print(",");
  Serial.print(accel.cx, 2);
  Serial.print(",");

  Serial.print(accel.cy, 2);

  Serial.print(">");
  Serial.println();
}


