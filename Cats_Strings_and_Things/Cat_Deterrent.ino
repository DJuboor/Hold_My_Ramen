const int pingPin = 7;
const int SW_PIN = 2;
const int buzzer = 4;
const int servo = 9;

int pos = 90;


unsigned long timeRef = 0; // Represents a (reference) point in time
boolean pingOn = false; // Flag to indicate whether the switch is on or off
#include <Servo.h>
Servo myservo; //create servo object to control a servo

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
    pinMode(SW_PIN, INPUT);
    pinMode(buzzer, OUTPUT);
    myservo.attach(servo);

}

  long microsecondsToInches(long microseconds) {
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds) {
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;}
  
void loop() {

  
  
  if (digitalRead(SW_PIN) == HIGH) {

for (pos = 90; pos <= 180; pos += 1) { // goes from 90 degrees to 180 degrees
    // in steps of 1 degree
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                       
    
    
      pingOn = !pingOn; // If true, becomes false. If false, becomes true
      digitalWrite(pingPin, pingOn);  // Updates the ping's state
 
    
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration, inches, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);

  Serial.print(inches);
  Serial.print("in, ");
  Serial.print(cm);
  Serial.print("cm");
  Serial.println();

  delay(100);

  timeRef = millis();  // The current moment is the new time reference
  
  if (inches<=10)
    {
    digitalWrite(buzzer, HIGH);
    }
   else
    {
    digitalWrite(buzzer, LOW);
    }
}


 for (pos = 180; pos >= 90; pos -= 1) { // goes from 180 degrees to 0 degrees
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                        
    
    
      pingOn = !pingOn; // If true, becomes false. If false, becomes true
      digitalWrite(pingPin, pingOn);  // Updates the ping's state
 
    
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration, inches, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);

  Serial.print(inches);
  Serial.print("in, ");
  Serial.print(cm);
  Serial.print("cm");
  Serial.println();

  delay(100);

  timeRef = millis();  // The current moment is the new time reference
  
  if (inches<=10)
    {
    digitalWrite(buzzer, HIGH);
    }
   else
    {
    digitalWrite(buzzer, LOW);
    }
}


}

if (digitalRead(SW_PIN) == LOW){

  for (pos=pos; pos >= 90; pos -= 1) { // goes back to 90 degrees
    myservo.write(pos);
}
}
}
