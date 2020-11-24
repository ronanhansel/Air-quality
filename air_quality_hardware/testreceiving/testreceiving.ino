#include <Firebase.h>
#include <FirebaseArduino.h>
#include <FirebaseCloudMessaging.h>
#include <FirebaseError.h>
#include <FirebaseHttpClient.h>
#include <FirebaseObject.h>
#include <SoftwareSerial.h>


#include <ESP8266WiFi.h>

#define WIFI_SSID ":L"
#define WIFI_PASSWORD "84568456"
#define FIREBASE_HOST "airify-b9e29.firebaseio.com"
#define FIREBASE_AUTH "myh0iX4HQA1TmZZWdRUr6pfObcWGJRK71TwOixZL"
float five;
float seven;
float onethreefive;
float humid;
float temp;
String number;

SoftwareSerial s(3,1);
void setup()
{

  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while(WiFi.status() != WL_CONNECTED) {
    Serial.print(". ");
    delay(1000);
    } 
    Serial.println("Connected");
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop()
{  
  if (Serial.available()) {
  number = Serial.readString();
  int n = number.length();
  Serial.println(n);
  char char_array[n + 1];
  strcpy(char_array, number.c_str());
  char *split = strtok(char_array, " ");
  char *splittwo = strtok(NULL, " ");
  char *splitthree = strtok(NULL, " ");
  char *splitfour = strtok(NULL, " ");
  char *splitfive = strtok(NULL, " ");
  five = atof(split);
  seven = atof(splittwo);
  onethreefive = atof(splitthree);
  humid = atof(splitfour);
  temp = atof(splitfive);

  Firebase.setFloat("5", five);
  Firebase.setFloat("7", seven); 
  Firebase.setFloat("135", onethreefive);
  Firebase.setFloat("humid", humid);
  Firebase.setFloat("temp", temp);
  


  // handle error 
  if (Firebase.failed()) { 
      Serial.println("setting number failed:"); 
      Serial.println(Firebase.error());  
      return; 
    }
  } 
    delay(1000);
}
