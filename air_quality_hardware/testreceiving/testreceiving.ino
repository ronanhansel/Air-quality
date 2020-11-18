#include <FirebaseArduino.h>
#include <ESP8266WiFi.h>

#define WIFI_SSID ":L"
#define WIFI_PASSWORD "84568456"
#define FIREBASE_HOST "https://airify-b9e29.firebaseio.com/"
#define FIREBASE_AUTH "myh0iX4HQA1TmZZWdRUr6pfObcWGJRK71TwOixZL"
void setup()
{
Serial.begin(9600);

  delay(2000);
  
  wifiConnect();

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  delay(10);
}

void loop()
{  
if(WiFi.status() != WL_CONNECTED)
{
  wifiConnect();

}
delay(10);

}

void wifiConnect()
{
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);             // Connect to the network

  int teller = 0;
  while (WiFi.status() != WL_CONNECTED)
  {                                       // Wait for the Wi-Fi to connect
    delay(1000);
    Serial.print(++teller); Serial.print(' ');
        // set value 
  Firebase.setFloat("number", 42.0); 
  // handle error 
  if (Firebase.failed()) { 
      Serial.print("setting /number failed:"); 
      Serial.println(Firebase.error());   
      return; 
  } 
  }
}
