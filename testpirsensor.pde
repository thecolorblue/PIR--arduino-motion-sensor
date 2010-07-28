/* 
 * //////////////////////////////////////////////////
 * //making sense of the Parallax PIR sensor's output
 * //////////////////////////////////////////////////
 *
 * Switches a LED according to the state of the sensors output pin.
 * Determines the beginning and end of continuous motion sequences.
 *
 * @author: Brad Davis / brad.bdavis1 (_) gmail (_) com / http://braddavis.cc
 * @date:   27, July, 2010
 *
 * 
 * released under a creative commons "Attribution-NonCommercial-ShareAlike 2.0" license
 * http://creativecommons.org/licenses/by-nc-sa/2.0/de/
 *
 * Lots of link love should go to
 * Kristian Gohlke (krigoo (_) gmail (_) com / http://krx.at) for creating the original 
 * project that some of this code was taken from. 
 * The Parallax PIR Sensor is an easy to use digital infrared motion sensor module. 
 * (http://www.parallax.com/detail.asp?product_id=555-28027)
 *
 * The sensor's output pin goes to HIGH if motion is present.
 * This sets off an led and a buzzer. The arduino then waits a set cool down time before
 * setting off the buzzer again. 
 *  
 */

/////////////////////////////
//VARS
//the time we give the sensor to calibrate (10-60 secs according to the datasheet)
int calibrationTime = 30;          

int pirPin = 3;    //the digital pin connected to the PIR sensor's output
int ledPin = 13;  // shows the state of the sensor
int bellPin = 12;  // represents the bell or buzzer that plays 
                   // when someone walks by the sensor
long binglength = 2000; // how long the buzzer/bell will play
long lasttime = 0; // stores the time of the last sensor tripping
long cooldown = 20000;  // time between buzzer plays
boolean cool = true;


/////////////////////////////
//SETUP
void setup(){
  Serial.begin(9600);
  pinMode(pirPin, INPUT);
  pinMode(ledPin, OUTPUT);
  pinMode(bellPin, OUTPUT);
  digitalWrite(pirPin, LOW);
  digitalWrite(bellPin, LOW);
  
  
  //give the sensor some time to calibrate
  Serial.print("calibrating sensor ");
    for(int i = 0; i < calibrationTime; i++){
      Serial.print(".");
      delay(1000);
      }
    Serial.println(" done");
    Serial.println("SENSOR ACTIVE");
    delay(50);
  }

////////////////////////////
//LOOP
void loop(){

     if(digitalRead(pirPin) == HIGH){ // sensor is tripped
       digitalWrite(ledPin, HIGH);
       Serial.println(lasttime/1000);
       if(cool == true) {
         lasttime = millis();
         digitalWrite(bellPin, LOW);
         cool = false;
       }
       else {
         Serial.print("sensor is hot");  // tells us why the buzzer might not be going off
       }
       delay(1000);
       
     }
     if(millis() > lasttime + binglength){  // turns off buzzer/bell/led
       
       digitalWrite(bellPin, HIGH);
     }
     if(millis() > lasttime + cooldown){  // resets cooldown
       cool = true;
     }
     if(digitalRead(pirPin) == LOW){
       digitalWrite(ledPin, LOW);
     }
}
     
