#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

#include<SoftwareSerial.h>
#define anInput     A2                        //analog feed from MQ135
#define co2Zero     55                        //calibrated CO2 0 level

#include "DHT.h"
#define DHTTYPE DHT11   // DHT 11
#define DHTPIN 6

DHT dht(DHTPIN, DHTTYPE);
float five;
float seven;
float onethreefive;
  String f;
int R2 = 2000;
int sensorValue;
float sensor_volt;
float RS_gas;
float ratio;
float RO;
  int co2now[10];                               //int array for co2 readings
  int co2raw = 0;                               //int for raw value of co2
  int co2ppm = 0;                               //int for calculated ppm
  int zzz = 0;                                  //int for averaging
LiquidCrystal_I2C lcd(0x27,20,4);

void setup() {
  Serial.begin(9600);
  pinMode(anInput,INPUT); 
  lcd.init();
  lcd.init();
  lcd.backlight();
  dht.begin();
  }
 void loop() {
    R0();
    fivees();
    sevens();
    onethreefives();
    humid_temp();
    sends();
    delay(1000);
  }
 void sends() {
   f = String(five)+String(" ")+String(seven)+String(" ")+String(onethreefive)+String(" ");
  Serial.print(f);
  }
 void fivees() {
  five = analogRead(A0);
  lcd.setCursor(0,0);
  lcd.print(five);
  lcd.setCursor(16,0);
  lcd.print("Gas");
  }
 void sevens() {
  seven = seven_ppm();
  lcd.setCursor(0,1);
  lcd.print(seven);
  lcd.setCursor(16,1);
  lcd.print("CO");
    }
 void onethreefives() {
  onethreefive = analogRead(A2);
  lcd.setCursor(0,2);
  lcd.print(onethreefive);
  lcd.setCursor(16,2);
  lcd.print("CO2");
  }
 void humid_temp() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  lcd.setCursor(0,3);
  lcd.print(h);
  lcd.setCursor(6,3);
  lcd.print("Humid");
  lcd.setCursor(12,3);
  lcd.print(t);
  lcd.setCursor(18,3);
  lcd.print("C");
  }
void R0() {
  int sensorValue = analogRead(A1);
  sensor_volt=(float)sensorValue/1024*5.0;
  RS_gas = ((5.0 * R2)/sensor_volt) - R2;
  RO = RS_gas / 1;
}
float seven_ppm() {
   sensorValue = analogRead(A1);
   sensor_volt = (float)sensorValue/1024*5.0;
   RS_gas = (5.0-sensor_volt)/sensor_volt;
   ratio = RS_gas/RO; //Replace RO with the value found using the sketch above
   float x = 1538.46 * ratio;
   float ppm = pow(x,-1.709);
   return (ppm);
}
