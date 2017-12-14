#include <Servo.h>
long t = 0;
#define PWM 3
#define LEFT 4
#define RIGHT 5
Servo servo;
int state = 1;
void setup() {

//SERIAL MONITOR
  Serial.begin(9600);
  while(!Serial);

  servo.attach(3);
  pinMode(LEFT, INPUT_PULLUP);
  pinMode(RIGHT, INPUT_PULLUP);
}

void loop() {
  if(digitalRead(LEFT)==LOW){ //Left Button Pressed?
    state = 0;
    servo.write(255);
    t=millis();
  }
  if(digitalRead(RIGHT) == LOW){ //Right Button Pressed?
    state = 2;
    servo.write(0);
    t=millis();
  }
  if(millis()-t > 2000){
    state = 1;
    servo.write(90);
  }
  Serial.println(state);
}
