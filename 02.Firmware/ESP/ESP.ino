#include <ArduinoJson.h>
#include <EEPROM.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <WiFiClient.h>
#include "config_page.h"

char ESPSSID[20]  = "ESP1457728";
char ESPPASS[20]  = "123456789";
char HOSTNAME[25];
int  PORT = 80;

ESP8266WebServer server(80);
WiFiClient esp;

StaticJsonDocument<100> doc;

char buff[40] = "";
int buffPos = 0;
char tmp[40];

bool isConfigMode = false;
bool changeServerName = false;
bool changePort = false;
bool hasNewData = false;

int temp = 0, humi = 0, lux = 0;

void setup() {
  Serial.begin(9600);
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAP(ESPSSID, ESPPASS);
  server.on("/", get_index_page);
  server.on("/save_config", save_config);
  server.on("/get_config", get_config);
  EEPROM.begin(100);
  initParam();
}

void loop() {
  checkDataReceive();
//  if(changeServerName == true){
//    int i;
//    for(i = 0; HOSTNAME[i] != 0; i++){
//      EEPROM.write(i, HOSTNAME[i]);
//    }
//    EEPROM.write(i, 0);
//    EEPROM.commit();
//    changeServerName = false;
//  }
//  if(changePort == true){
//    EEPROM.write(30, PORT >> 8);
//    EEPROM.write(31, PORT & 0xFF);
//    EEPROM.commit();
//    changePort = false;
//  }
  if(hasNewData == true){
    Serial.println(sendRequest());
    hasNewData = false;
  }
}

void checkDataReceive(){
  if(Serial.available()){
    while(Serial.available()){
      char c = Serial.read();
      buff[buffPos++] = c;
      if(c == '}'){
        process(buff);
        buffPos = 0;
      }
    }
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
  if(server.arg("server").length() > 0){
    for(i = 0; i < server.arg("server").length(); i++){
      EEPROM.write(i, server.arg("server")[i]);
    }
    EEPROM.write(i, 0);
    EEPROM.commit();
  }
  // Save port
  if(server.arg("port").length() > 0){
    PORT = 0;
    for(int i = 0; i < server.arg("port").length(); i++){
      PORT = PORT * 10 + server.arg("port")[i] - '0';
    }
    EEPROM.write(30, PORT >> 8);
    EEPROM.write(31, PORT & 0xFF);
    EEPROM.commit();
  }
  // End config mode
  delay(1000);
  isConfigMode = false;
  Serial.println("{message:END_CONFIG_MODE}");
}

void get_config(){
  server.send(200, "text/plain", String("Server config: ") + String(HOSTNAME) + String(":") + String(PORT));
}

void initParam(){
  int i = 0;
  while(true){
    HOSTNAME[i] = EEPROM.read(i);
    if(i == 25 || HOSTNAME[i] == 0)
      break;
    i++;
  }
  PORT = EEPROM.read(30);
  PORT = (PORT << 8) + EEPROM.read(31);
}

void process(char *buff){
  DeserializationError error = deserializeJson(doc, buff);
  if(error);
  else{
    const char *cmd = doc["cmd"];
    if(cmd == NULL){
      //       
    }
    else{
      if(strcmp(cmd, "CONFIG") == 0){
        Serial.println("{message:IN_CONFIG_MODE}");
        isConfigMode = true;
        server.begin();
        while(isConfigMode == true){
          server.handleClient();
          delay(5);
        }
      }
      else if(strcmp(cmd, "SEND") == 0){
        temp = doc["data"][0];
        humi = doc["data"][1];
        lux = doc["data"][2];
        hasNewData = true;
      }
      else if(strcmp(cmd, "GETSERVER") == 0){
        Serial.print("Get hostname from EEPROM: ");
        Serial.print(HOSTNAME);
        Serial.print(" Port: ");
        Serial.println(PORT);
      }
      else if(strcmp(cmd, "GETWIFISTATUS") == 0){
        if(WiFi.status() == WL_CONNECTED)
          Serial.println("{message:WIFI_CONNECTED}");
        else
          Serial.println("{message:WIFI_NOT_CONNECTED}");
      }
    }
  }
}

String sendRequest(){
  String resp;
  esp.connect(HOSTNAME, PORT);
  if(esp.connected()){
    if(temp > 0 && humi > 0)
      sprintf(tmp, "?temp=%d&humi=%d&lux=%d", temp, humi, lux);
    esp.print("GET /giamsatkhongkhi/main.php");
    delay(1);
    esp.print(tmp);
    delay(1); 
    esp.print(" HTTP/1.0\r\nHost: ");
    delay(1); 
    esp.print(HOSTNAME);
    delay(1);
    esp.print("\r\n\r\n");
    unsigned long times = millis();
    resp = "";
    bool isStart = false;
    while(millis() - times <= 4000){
      if(esp.available()){
        while(esp.available()){
          char c = esp.read();
          if(c == '{')
            isStart = true;
          if(isStart == true)
            resp += c;
        }
        break;
      }
    }
    esp.stop();
    resp = "control:" + resp;
  }
  return resp;
}
