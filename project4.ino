const int SW_pin = 2;
const int X_pin = 0;
const int Y_pin = 1;

const int led = 8; 

const int button = 12;

char val;
boolean lightOn = false;

void setup() {
  //joystick
  pinMode(SW_pin, INPUT);
  digitalWrite(SW_pin, HIGH);

  //led pin
  pinMode(led, OUTPUT);

  //push button
  pinMode(button, INPUT);

  Serial.begin(9600);
  establishContact();
  
}

void loop() {
  int buttonState;
  buttonState = digitalRead(button);
  if(buttonState == HIGH) {
    Serial.print("BUTTON-PRESSED");
    Serial.print("\n");
  } else if (buttonState == LOW) {
    Serial.print("BUTTON-RELEASED");
    Serial.print("\n");
  }
  
  Serial.print("X-axis: ");
  Serial.print(analogRead(X_pin));
  Serial.print("\n");
  Serial.print("Y-axis: ");
  Serial.println(analogRead(Y_pin));
  Serial.print("\n");

  if(lightOn) {
    Serial.print("LIGHT-ON");
    Serial.print("\n");
  } else {
    Serial.print("LIGHT-OFF");
    Serial.print("\n");
  }
  
  if (Serial.available() > 0) {
    
     val = Serial.read();
     if (val == '1') {
        digitalWrite(led,HIGH);
        lightOn = true;
     } else if(val == '0') {
        digitalWrite(led,LOW);
        lightOn = false;
     }
     
  }
  
  delay(10);

}

void establishContact() {
  while (Serial.available() <= 0) {
  Serial.println("A");   // send a capital A
  delay(10);
  }
}
