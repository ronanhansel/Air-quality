int data; //Initialized variable to store recieved data

void setup() {
  //Serial Begin at 9600 Baud 
  Serial.begin(9600);
}

void loop() {
  data = Serial.read(); //Read the serial data and store it
  delay(1000);
}
