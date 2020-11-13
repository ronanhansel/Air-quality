int co;
int carbon_dioxide;
int air_quality;
void setup() {
  Serial.begin(9600);
  }
 void loop() {
  co = analogRead(A0);
  carbon_dioxide = analogRead(A1);
  air_quality = analogRead(A2);
  Serial.print(co);
  Serial.println(" Gas");
  Serial.print(carbon_dioxide);
  Serial.println(" CO2");
  Serial.print(air_quality);
  Serial.println(" Air Quality");
  delay(1000);
  }
