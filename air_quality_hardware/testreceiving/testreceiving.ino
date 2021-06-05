#include <SoftwareSerial.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Nhà của Cún :L"
#define WIFI_PASSWORD "84568456"
#define FIREBASE_HOST "airify-b9e29.firebaseio.com/"
#define FIREBASE_AUTH "myh0iX4HQA1TmZZWdRUr6pfObcWGJRK71TwOixZL"

/* 2. Define the API Key */
#define API_KEY "AIzaSyDpZUcEEgp86Ad-eZTgDfdFI1G0BSaeOdQ"

/* 3. Define the RTDB URL */
#define DATABASE_URL "airify-b9e29.firebaseio.com" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "hanselronan@gmail.com"
#define USER_PASSWORD "Ronanhans_0711"

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

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
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
#define FIREBASE_FCM_SERVER_KEY "AAAAwZW1mqA:APA91bEoA3eTrSYqk_TzGfDqL3zs8NijKvRuVCXt0cFyPlc1q1Y2X2iCxktKVtVtk8BRGq7NZ03WKc-esU1jmI68fsp4JuMPRohPDm4bjq4WunQeBgdFI3M3ItLsZv7r_oSl0_KnL7cC "

/* 3. Define the ID token for client or device to send the message */
#define DEVICE_REGISTRATION_ID_TOKEN "DEVICE_TOKEN"
  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;
  config.signer.tokens.legacy_token = "myh0iX4HQA1TmZZWdRUr6pfObcWGJRK71TwOixZL";

  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);
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
  Serial.printf("Set 5... %s\n", Firebase.RTDB.setFloat(&fbdo, "/5", five) ? "ok" : fbdo.errorReason().c_str());
  Serial.printf("Set 7... %s\n", Firebase.RTDB.setFloat(&fbdo, "/7", seven) ? "ok" : fbdo.errorReason().c_str());
  Serial.printf("Set 135... %s\n", Firebase.RTDB.setFloat(&fbdo, "/135", onethreefive) ? "ok" : fbdo.errorReason().c_str());
  Serial.printf("Set humid... %s\n", Firebase.RTDB.setFloat(&fbdo, "/humid", humid) ? "ok" : fbdo.errorReason().c_str());
  Serial.printf("Set temp... %s\n", Firebase.RTDB.setFloat(&fbdo, "/temp", temp) ? "ok" : fbdo.errorReason().c_str());
  } else {
    Serial.println("No");
    }
    delay(1000);
}
