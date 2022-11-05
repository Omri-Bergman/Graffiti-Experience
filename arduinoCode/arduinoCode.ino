#define xPin A0
#define yPin A1
#define potentiometer A4
#define fsrPin A3     // the FSR and 10K pulldown are connected to a0
#define trigger 2
#define echo 3
#define bPin 8
#define photon_a 10
#define photon_b 11
#define vibePin A5


const float  V = 0.034;

float duration, xValue, yValue, bValue, pressureValue, distance, fsrReading, red, green, blue, color, vibe;
int pho_a, pho_b;

void setup(void) {
  Serial.begin(9600);
  pinMode(bPin, INPUT);
  digitalWrite(bPin, HIGH);
  pinMode(trigger, OUTPUT);
  pinMode(echo, INPUT);
  pinMode(photon_a, INPUT);
  pinMode(photon_b, INPUT);
}

void loop(void) {
  // xValue,yValue,joystickButton, pressure, sonar - in cm, color[3]

  // Joystick
  xValue = analogRead(xPin) + 2;
  yValue = analogRead(yPin) - 11;
  bValue = digitalRead(bPin);

  // FSR
  fsrReading = analogRead(fsrPin);
  pressureValue = fsrReading;
  //vibe
   analogWrite(vibePin, map(pressureValue, 0, 200, 0, 255));

  //  Serial.print((int)vibe, DEC);


  // Sonar
  //  distance = 0.5 * distance + 0.5 * getSonar();
  distance = getSonar();

  // Color Picker
  color = analogRead(potentiometer) ;

  //  //light
  pho_a = digitalRead(photon_a);
  pho_b = digitalRead(photon_b);




  //  Serial.print("%f,%f,%f,%f,%f,%d,%d,%d\n",xValue, yValue, !bValue, pressureValue, distance, color, ( red, green, blue));
  Serial.print((int)xValue, DEC);
  Serial.print(",");
  Serial.print((int)yValue, DEC);
  Serial.print(",");
  Serial.print(!bValue);
  Serial.print(",");
  Serial.print((int)pressureValue, DEC);
  Serial.print(",");
  Serial.print((int) distance, DEC);
  Serial.print(",");
  Serial.print((int)color, DEC);
  Serial.print(",");
  Serial.print(pho_a);
  Serial.print(",");
  Serial.print(pho_b);
  Serial.print("\n");
  delay(10);
}


float getSonar() {
  // reset
  digitalWrite(trigger, LOW);
  delayMicroseconds(3);

  // pulse
  digitalWrite(trigger, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigger, LOW);
  duration = pulseIn(echo, HIGH);
  return dist(duration);
}

float dist(float duration) {
  return duration * V / 2;
}
