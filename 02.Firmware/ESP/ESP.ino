#include <EEPROM.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <FirebaseArduino.h>
#include "config_page.h"

#define DEBUG     true

#define FIREBASE_HOST "patientcare-59fee-default-rtdb.asia-southeast1.firebasedatabase.app"
#define FIREBASE_AUTH "V4eaCNzjq3KyRepANQjgUznwQ3EAZKpYHpG4veDp"

// WiFi info for AP
char ESPSSID[20]  = "ESP1457728";
char ESPPASS[20]  = "123456789";
// WiFi info for connecting
char WIFI_SSID[20];
char WIFI_PASS[20];
char UID[30]      = "Z27krdkzL8S3v9itCNsq9XPEsZr2";

ESP8266WebServer server(80);
WiFiClient esp;

char inBuff[40];
char outBuff[40] = {0x84, 0xF0};
int buffPos = 0;

bool isConfigMode = false;

unsigned long updateTime = 0;
int wifiTmout;

void setup() {
  Serial.begin(9600);
#if DEBUG  
  Serial.println("Init ESP8266...");
#endif
  EEPROM.begin(100);
  initParam();
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAP(ESPSSID, ESPPASS);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  wifiTmout = 0;
  while (WiFi.status() != WL_CONNECTED && wifiTmout < 12) {
#if DEBUG  
    Serial.print(".");
#endif
    wifiTmout++;
    delay(500);
  }
#if DEBUG
  if(WiFi.status() == WL_CONNECTED){
    Serial.println("Wifi connected");
    Serial.println(WiFi.localIP());
  }
#endif
  server.on("/", get_index_page);
  server.on("/save_config", save_config);
  server.on("/get_config", get_config);
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  checkReceiveCommand();
  if(isConfigMode == true){   // in config mode
    server.handleClient();
    delay(5);
  }
  else{   // normal mode
    if(millis() - updateTime >= 1000){
      outBuff[2] = 0x83;
      outBuff[3] = Firebase.getInt(UID + String("/RELAY1"));
      outBuff[4] = Firebase.getInt(UID + String("/RELAY2"));
      sendCommand(outBuff, 5);
      updateTime = millis();
    }
  }
}

void checkReceiveCommand(){
  if(Serial.available()){
    while(Serial.available()){
      inBuff[buffPos++] = (char) Serial.read();
      delay(2);
    }
  }
  if(buffPos != 0){
    processCommand();
  }
}

void get_index_page(){
  server.send(200, "text/html", index_page);
}

void save_config(){
  int i;
  // Send notification
  server.send(200, "text/plain", "Saved successful!");
  // Save wifi information
  if(server.arg("ssid").length() > 0){
    WiFi.begin(server.arg("ssid"), server.arg("pass"));
  }
  // Save server name
  if(server.arg("uid").length() > 0){
    for(i = 0; i < server.arg("uid").length(); i++){
      EEPROM.write(i, server.arg("uid")[i]);
    }
    EEPROM.write(i, 0);
    EEPROM.commit();
  }
  // End config mode
  delay(1000);
  isConfigMode = false;
  outBuff[2] = 0x81;
  outBuff[3] = 0x82;
  sendCommand(outBuff, 4);  // notify to MCU when finish config mode
  server.stop();
#if DEBUG
  Serial.println("Finish config mode");
#endif
}

void get_config(){
  server.send(200, "text/plain", String("Server config: WIFI ") + String(WIFI_SSID) + String("/") + String(WIFI_PASS));
}

void initParam(){
  int i = 0;
  while(true){
    WIFI_SSID[i] = EEPROM.read(i);
    if(i == 25 || WIFI_SSID[i] == 0)
      break;
    i++;
  }
  WIFI_SSID[i] = 0;
  i = 0;
  while(true){
    WIFI_PASS[i] = EEPROM.read(i + 25);
    if(i == 25 || WIFI_PASS[i] == 0)
      break;
    i++;
  }
  WIFI_PASS[i] = 0;
  i = 0;
  while(true){
    UID[i] = EEPROM.read(i + 50);
    if(i == 35 || UID[i] == 0)
      break;
    i++;
  }
  UID[i] = 0;
}

void processCommand(){
#if DEBUG
    for(int i = 0; i < buffPos; i++){
      Serial.print(inBuff[i], HEX);
      Serial.print(" ");
    }
    Serial.println();
#endif
  if(inBuff[0] == 0x84 && inBuff[1] == 0xF0){
    switch(inBuff[2]){
      case 0x80:
        if(inBuff[3] == 0x81){  // start Wifi config mode
#if DEBUG
          Serial.println("Enter Wifi config mode");
#endif    
          isConfigMode = true;
          server.begin();
        }
        else if(inBuff[3] == 0x82){   // stop Wifi config mode
#if DEBUG
          Serial.println("Exit Wifi config mode");
#endif          
          isConfigMode = false;
          server.stop();
        }
        else if(inBuff[3] == 0x83){   // Reset ESP8266
          ESP.reset();
        }
        else if(inBuff[3] == 0x84){   // Get Wifi connection status
          
        }
        break;
      case 0x82:
        if(inBuff[3] == 0x81){  // Send DHT11 temp and humi to Firebase
          Firebase.setInt(UID + String("/Air_Temp"), inBuff[4]);
          Firebase.setInt(UID + String("/Air_Humi"), inBuff[5]); 
        }
        else if(inBuff[3] == 0x82){   // Send Heart rate, SpO2 and Body temp to Firebase
          Firebase.setInt(UID + String("/Heart"), (((int) inBuff[4]) << 8) | inBuff[5]);
          Firebase.setInt(UID + String("/SpO2"), inBuff[6]);
          Firebase.setInt(UID + String("/Body_Temp"), inBuff[7]);
        }
        else if(inBuff[3] == 0x83){   // Send SOS status to Firebase
          Firebase.setInt(UID + String("/SOS"), inBuff[4]);
        }
        break;
    }
  }
  buffPos = 0;
}

void sendCommand(char cmd[], int len){
  for(int i = 0; i < len; i++){
    Serial.print(cmd[i]);
  }
}
