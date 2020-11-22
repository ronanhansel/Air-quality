#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

#include <FirebaseCloudMessaging.h> 
 
#define WIFI_SSID     ":L"
#define WIFI_PASSWORD "84568456"

//FOR FirebaseCloudMessaging.h which is not working
#define SERVER_KEY "AAAAwZW1mqA:APA91bEoA3eTrSYqk_TzGfDqL3zs8NijKvRuVCXt0cFyPlc1q1Y2X2iCxktKVtVtk8BRGq7NZ03WKc-esU1jmI68fsp4JuMPRohPDm4bjq4WunQeBgdFI3M3ItLsZv7r_oSl0_KnL7cC"
#define CLIENT_REGISTRATION_ID "YOU HAVE TO MAKE A LOT WORK TO FIND YOUR ANDROID REG ID"
//THIS WILL GIVE AN IDEA https://github.com/arnesson/cordova-plugin-firebase
#define TOPIK     "TOPIK"
//FOR FirebaseCloudMessaging.h which is not working

WiFiClient client;
String serve = "PUT YOUR GCM KEY";
String reg = "YOU HAVE TO MAKE A LOT WORK TO FIND YOUR ANDROID REG ID";
//THIS WILL GIVE AN IDEA https://github.com/arnesson/cordova-plugin-firebase
String top = "TOPIK";


void setup() {
  Serial.begin(9600);
  Serial.setDebugOutput(true);
  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
 
  //NO NEED
  FirebaseCloudMessaging fcm(SERVER_KEY);
  //NO CHANCE
  FirebaseCloudMessage message =
    FirebaseCloudMessage::SimpleNotification("Hello World!", "What's happening?");
  FirebaseError error = fcm.SendMessageToUser(CLIENT_REGISTRATION_ID, message);
  if (error) {
    Serial.print("Error:");
    Serial.print(error.code());
    Serial.print(" :: ");
    Serial.println(error.message().c_str());
  } else {
    Serial.println("Sent OK!");
  }
  //NO CHANCE
  FirebaseCloudMessage messageTOPIK =
    FirebaseCloudMessage::SimpleNotification("Hello World!TOPIK", "What's happening?TOPIK");
  FirebaseError errorTOPIK = fcm.SendMessageToTopic(TOPIK, message);
  if (errorTOPIK) {
    Serial.print("ErrorError:");
    Serial.print(errorTOPIK.code());
    Serial.print(" :: ");
    Serial.println(errorTOPIK.message().c_str());
  } else {
    Serial.println("Sent OKOK!");
  }
  //NO CHANCE


}


HTTPClient http;
void doit(String paytitle, String pay) {
  //more info @ https://firebase.google.com/docs/cloud-messaging/http-server-ref

  String data = "{";
  data = data + "\"to\": \"" + reg + "\",";
  data = data + "\"notification\": {";
  data = data + "\"body\": \"" + pay + "\",";
  data = data + "\"title\" : \"" + paytitle + "\" ";
  data = data + "} }";

  http.begin("http://fcm.googleapis.com/fcm/send");
  http.addHeader("Authorization", "key=" + serve);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("Host", "fcm.googleapis.com");
  http.addHeader("Content-Length", String(pay.length()));
  http.POST(data);
  http.writeToStream(&Serial);
  http.end();
  Serial.println();

}

HTTPClient httpTOPIK;
void doitTOPIC(String paytitle, String pay, String top) {
  //more info @ https://firebase.google.com/docs/cloud-messaging/http-server-ref


  String data = "{";
  data = data + "\"to\": \"/topics/" + top + "\",";
  data = data + "\"notification\": {";
  data = data + "\"body\": \"" + pay + "\",";
  data = data + "\"title\" : \"" + paytitle + "\" ";
  data = data + "} }";

  httpTOPIK.begin("http://fcm.googleapis.com/fcm/send");
  httpTOPIK.addHeader("Authorization", "key=" + serve);
  httpTOPIK.addHeader("Content-Type", "application/json");
  httpTOPIK.addHeader("Host", "fcm.googleapis.com");
  httpTOPIK.addHeader("Content-Length", String(pay.length()));
  httpTOPIK.POST(data);
  httpTOPIK.writeToStream(&Serial);
  httpTOPIK.end();
  Serial.println();

}

//DIRTY WAY
void sendDataToFirebase() {
  String data = "{";
  data = data + "\"to\": \"" + reg + "\",";
  data = data + "\"notification\": {";
  data = data + "\"body\": \"orAway\",";
  data = data + "\"title\" : \"Non\" ";
  data = data + "} }";
  Serial.println("Send data...");
  if (client.connect("fcm.googleapis.com", 80)) {
    Serial.println("Connected to the server..");
    client.println("POST /fcm/send HTTP/1.1");
    client.println("Authorization: key=" + serve + "");
    client.println("Content-Type: application/json");
    client.println("Host: fcm.googleapis.com");
    client.print("Content-Length: ");
    client.println(data.length());
    client.print("\n");
    client.print(data);
  }
  Serial.println("Data sent...Reading response..");
  while (client.available()) {
    char c = client.read();
    Serial.print(c);
  }
  Serial.println("Finished!");
  client.flush();
  client.stop();
}
void loop() {
  // doit("quick", "silver"); //clear way with reg_id
  doitTOPIC("Mr&Mrs", "Brown", top); //clear way with topic
  // doitTOPIC("title", "body", "yourverycustomtopic");

  delay(13000);

  //sendDataToFirebase(); dirty way

}
