#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
int five;
int seven;
int onethreefive;


LiquidCrystal_I2C lcd(0x27,20,4);

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.init();
  }
 void loop() {
fivees();
sevens();
onethreefives();
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
  seven = analogRead(A1);
  lcd.backlight();
  lcd.setCursor(0,1);
  lcd.print(seven);
  lcd.setCursor(5,1);
  lcd.print("CO");
    }
 void onethreefives() {
  onethreefive = analogRead(A2);
  lcd.backlight();
  lcd.setCursor(0,2);
  lcd.print(onethreefive);
  lcd.setCursor(5,2);
  lcd.print("Air Quality");
  delay(1000);
  }
