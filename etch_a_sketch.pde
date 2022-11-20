/*
  Etch-a-Sketch
  By Morgan Redfield
  13 June 2010
  
  Connect to an Arduino (running Firmata) and read analog values on analog0 and analog1.
  Use the analog values that you read to draw a line that goes in various directions.
*/

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int left_right = 0;
int up_down = 1;
int toggle = 0;

float[] current_pos = new float[2];

void setup() {
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(13, Arduino.INPUT);
  size(400, 400);
  current_pos[0] = height/2;
  current_pos[1] = width/2;
}

int beginning = 0;
void draw() {
  if (beginning == 0) {
    beginning = 1;
    while (arduino.analogRead(left_right) == 0) {};
    while (arduino.analogRead(up_down) == 0) {};
  }
  int x = arduino.analogRead(left_right);
  int y = arduino.analogRead(up_down);

  if (x > 600) {
    x = 600 - x;  
  } else if (x < 400) {
    x = 400 - x; 
  } else {
    x = 0; 
  }
  x = x / 100;
  if (y > 600) {
    y = 600 - y;  
  } else if (y < 400) {
    y = 400 - y; 
  } else {
    y = 0; 
  }
  y = y/100;
  //println(arduino.analogRead(left_right));
  line(current_pos[0], current_pos[1], current_pos[0] + x, current_pos[1] + y);
  /*print(x);
  print(", ");
  println(y);*/
  current_pos[0] = current_pos[0] + x;
  current_pos[1] = current_pos[1] + y;
  delay(100);
  
  if (arduino.digitalRead(13) == Arduino.HIGH) {
    //println("button down");
    if (toggle == 0) {
      toggle = 1;
      saveFrame("etch_a_sketch-####");
    } 
  } else {
    toggle = 0; 
  }
}
