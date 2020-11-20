#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

#include<SoftwareSerial.h>
#define anInput     A2                        //analog feed from MQ135
#define co2Zero     55                        //calibrated CO2 0 level

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
SoftwareSerial s(0,1);
LiquidCrystal_I2C lcd(0x27,20,4);

void setup() {
  Serial.begin(9600);
  pinMode(anInput,INPUT); 
  lcd.init();
  lcd.init();
  s.begin(9600);
  }
 void loop() {
R0();
fivees();
sevens();
onethreefives();
sends();
delay(1000);
  }
 void sends() {
   f = String(five)+String(" ")+String(seven)+String(" ")+String(onethreefive)+String(" ");
  Serial.print(f);
  }
 void fivees() {
  five = analogRead(A0);
  lcd.backlight();
  lcd.setCursor(0,0);
  lcd.print(five);
  lcd.setCursor(5,0);
  lcd.print("Gas");
  }
 void sevens() {
  seven = seven_ppm();
  lcd.backlight();
  lcd.setCursor(0,1);
  lcd.print(seven);
  lcd.setCursor(5,1);
  lcd.print("CO");
    }
 void onethreefives() {
  onethreefive = co2();
  lcd.backlight();
  lcd.setCursor(0,2);
  lcd.print(onethreefive);
  lcd.setCursor(5,2);
  lcd.print("Air Quality");
  }
void R0() {
  int sensorValue = analogRead(A0);
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


float onethreefive_ppm() {
   sensorValue = analogRead(A2);
   sensor_volt = (float)sensorValue/1024*5.0;
   RS_gas = (5.0-sensor_volt)/sensor_volt;
   ratio = RS_gas/RO; //Replace RO with the value found using the sketch above
   float x = 1538.46 * ratio;
   float ppm = pow(x,-1.709);
   return (ppm);
}
  
int co2() 
{
  



  for (int x = 0;x<10;x++)  //samplpe co2 10x over 2 seconds
  {                   
    co2now[x]=analogRead(A2);
    delay(200);
  }

  for (int x = 0;x<10;x++)  //add samples together
  {                     
    zzz=zzz + co2now[x];  
  }
  co2raw = zzz/10;                            //divide samples by 10
  co2ppm = co2raw - co2Zero;                 //get calculated ppm
  return abs(co2ppm);            

}
