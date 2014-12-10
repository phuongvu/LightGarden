//LightGarden Reciever Code, 2014

#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11); // RX, TX


int value, value2 ;
int ledpin = 3;                           
int ledpin2 = 5;                        
int ledpin3 = 6;    
long time=0;
long lastTime = 0;


int periode = 2000;
int displace = 500;


int serialDelay = 0;

void setup()  
{
  
  pinMode(3, OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  
  
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }


  // set the data rate for the SoftwareSerial port
  mySerial.begin(9600);
  
}

void loop() 
{
  
  
   time = millis();
    if (mySerial.available()){
   if (millis() - lastTime >= serialDelay) {
   
    Serial.write(mySerial.read());

   lastTime = millis();
  }
   }
   
  value = 128+127*cos(2*PI/periode*time);
 
  analogWrite(ledpin, value);           // sets the value (range from 0 to 255) 
  analogWrite(ledpin2, value);           // sets the value (range from 0 to 255) 

 analogWrite(ledpin3, value); 


}


