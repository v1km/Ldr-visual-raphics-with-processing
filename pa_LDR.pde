/*
*  pa_LDR
 *  
 *  Reads the values which represent the state of a light sensor 
 *  from the serial port and draws a graphical representation.
 * 
 *  This file is part of the Arduino meets Processing Project.
 *  For more information visit http://www.arduino.cc.
 *
 *  copyleft 2005 by Melvin Ochsmann for Malm� University
 *  Updated by Spekel (http://www.spekel.se) , 2010
 */

// importing the processing serial class
import processing.serial.*;

// the display item draws background and grid
DisplayItems di;

// definition of window size and framerate

int fr = 24;

// attributes of the display 
boolean bck = true;
boolean grid = true;
boolean g_vert = true;
boolean g_horiz = true;
boolean g_values = false;
boolean output = false;

// variables for serial connection, portname and baudrate have to be set 
Serial port;
String portname; 
int baudrate = 9600;
int value = 0; 
String buf=""; 
int value1 = 0;  

// variables to draw graphics
int x, y, cursorSize;
int cnt = 6; 

// lets user control DisplayItems properties and value output in console
void keyPressed() {
  if (key == 'b' || key == 'B') bck=!bck;  // background black/white
  if (key == 'g' || key == 'G') grid=!grid;  // grid ON/OFF 
  if (key == 'v' || key == 'V') g_values=!g_values;  // grid values ON/IFF   
  if (key == 'o' || key == 'O') output=!output;   //turns value output ON/OFF
}

void setup() {
  // Print the a list of available Serial Ports
  println(Serial.list()[0]);
  // Set the Serial port from the listin [] field
  portname = Serial.list()[0];
  // set size and framerate
  size(512,512); 
  frameRate(fr);
  // establish serial port connection      
  port = new Serial(this, portname, baudrate);
  println(port);
  // create DisplayItems object
  di = new DisplayItems();
  ellipseMode(CENTER);
  smooth();
}

void drawLDRState() {
  cnt++; 
  if(cnt>24)  cnt = 6; 
  strokeWeight(2);
  stroke(0);
  noFill();
  x = width/2;
  y = height/2;

  cursorSize = 5 + cnt*(value1/50);

  ellipse(x, y, cursorSize, cursorSize); 
  stroke(255,0,0);
  ellipse(x, y, cursorSize-14, cursorSize-14); 
  stroke(0,255,0);
  ellipse(x, y, cursorSize-8, cursorSize-8); 
  stroke(0,0,255);
  ellipse(x, y, cursorSize-20, cursorSize-20); 
  stroke(255);
  ellipse(x, y, cursorSize, cursorSize);
}
void serialEvent(int serial) {
  // if serial event is not a line break 
  if(serial!=10) {        
    // add event to buffer
    buf += char(serial);
  } 
  else {
    // if serial is line break set value1 to buff and clear it
    value1 = 1023 - int(buf); // we inverse the value by subtracting it from the maximum
    buf="";
  }
  if(output) println("LDR: "+value1);
}

// draw listens to serial port, draw 
void draw() {
  // listen to serial port and trigger serial event  
  while(port.available() > 0) {
    value = port.read();
    serialEvent(value);
  }
  // draw background, then PushButtonState and finally rest of DisplayItems   
  di.drawBack();
  drawLDRState();
  di.drawItems();
}