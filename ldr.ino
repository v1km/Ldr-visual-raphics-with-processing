
  int analogInput = 3;
  int LEDpin = 13;
  
// variable to store the value 
  int value = 0;
  
// a threshold to decide when the LED turns on
  int threshold = 512;
 
void setup(){

// declaration of pin modes
  pinMode(analogInput, INPUT);
  pinMode(LEDpin, OUTPUT);
  
// begin sending over serial port
  Serial.begin(9600);
}

void loop(){
// read the value on analog input
  value = analogRead(analogInput);

// if value greater than threshold turn on LED
if (value < threshold) digitalWrite(LEDpin, HIGH); else digitalWrite(LEDpin, LOW);

// print out value over the serial port
 // printInteger(value);
Serial.print(value,DEC);
// and a signal that serves as seperator between two values 
  //printByte(10);
Serial.write(10);
// wait for a bit to not overload the port
  delay(10);  
}
