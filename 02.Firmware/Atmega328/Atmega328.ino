#include "config.h"
#include <LiquidCrystal.h>
#include <SoftwareSerial.h>
#include <Wire.h>
#include <MAX30100_PulseOximeter.h>
#include <DHT.h>

SoftwareSerial esp(ESP_TX, ESP_RX);
LiquidCrystal LCD(LCD_RS, LCD_EN, LCD_D4, LCD_D5, LCD_D6, LCD_D7);
PulseOximeter  pox;
DHT dht(DHT_PIN, DHT11);

unsigned long timer_100ms, timer_1s = 0, timer_5s = 0;
int sosbtn_cnt = 0, cfgbtn_cnt = 0;
unsigned char sos_status = 0, cur_disp = 0;

int heart, spo2, body_temp, temp, humi;

unsigned char inBuff[20], outBuff[20] = {0x84, 0xF0};
int buffPos = 0;

void setup(){
  Serial.begin(9600);
  gpioInit();
  LCD.begin(16, 2);
  LCD.print("Patient Care");
  pox.begin();
  dht.begin();
  esp.begin(9600);
  // Reset ESP
  outBuff[2] = 0x80;
  outBuff[3] = 0x83;
  sendCommand(outBuff, 4);
  delay(500);   // wait 500ms
  // ESP connect to WiFi
  outBuff[2] = 0x80;
  outBuff[3] = 0x85;
  sendCommand(outBuff, 4);
}

void loop(){
  checkReceiveCommand();
  if(millis() - timer_100ms >= 100){
    pox.update();
    checkSOSBtn();
    checkCfgBtn();
    timer_100ms = millis();
  }
  if(millis() - timer_1s >= 1000){
    updateHeartRateSpO2();
    timer_1s = millis();
  }
  if(millis() - timer_5s >= 5000){
    updateTempHumi();
    timer_5s = millis();
  }
}

void updateHeartRateSpO2(){
  heart = pox.getHeartRate();
  spo2 = pox.getSpO2();
  body_temp = analogRead(LM35) / 1023.0 * 500;
  LCD.clear();
  LCD.setCursor(0, 0);
  LCD.print("H:");
  LCD.print(heart);
  LCD.print(" ");
  LCD.print("SpO2:");
  LCD.print(spo2);
  LCD.setCursor(0, 1);
  LCD.print("BTemp:");
  LCD.print(body_temp);
  outBuff[2] = 0x82;
  outBuff[3] = 0x82;
  outBuff[4] = (heart >> 8) & 0xFF;
  outBuff[5] = heart & 0xFF;
  outBuff[6] = spo2;
  outBuff[7] = body_temp;
  sendCommand(outBuff, 8);
}

void updateTempHumi(){
  temp = dht.readTemperature();
  humi = dht.readHumidity();
  outBuff[2] = 0x82;
  outBuff[3] = 0x81;
  outBuff[4] = temp;
  outBuff[5] = humi;
  sendCommand(outBuff, 6);
}

void checkSOSBtn(){
  if(SOS_GET == LOW){
    if(sosbtn_cnt < 20){
      sosbtn_cnt++;
      if(sosbtn_cnt == 20){ // press and hold the SOS button in 2s
        sos_status = !sos_status;
        // send the SOS status to ESP
        outBuff[2] = 0x82;
        outBuff[3] = 0x83;
        outBuff[4] = sos_status;
        sendCommand(outBuff, 5);
      }
    }
  }
  else{
    sosbtn_cnt = 0;
  }
}

void checkCfgBtn(){
  if(ESP_CFG_GET == LOW){
    if(cfgbtn_cnt < 20){
      cfgbtn_cnt++;
      if(cfgbtn_cnt == 3){    // switch info displayed in LCD
        cur_disp = (cur_disp + 1) % 2;
      }
      else if(cfgbtn_cnt == 20){    // enter ESP config mode
        cur_disp = 2;
        outBuff[2] = 0x80;
        outBuff[3] = 0x81;
        sendCommand(outBuff, 4);
      }
    }
  }
  else{
    cfgbtn_cnt = 0;
  }
}

void checkReceiveCommand(){
  if(esp.available()){
    while(esp.available()){
      inBuff[buffPos++] = (char) esp.read();
      delay(2);
    }
  }
  if(buffPos != 0){
    processCommand();
  }
}

void processCommand(){
  for(int i = 0; i < buffPos; i++){
    Serial.print(inBuff[i], HEX);
    Serial.print(" ");
  }
  Serial.println();
  if(inBuff[0] == 0x84 && inBuff[1] == 0xF0){
    switch(inBuff[2]){
      case 0x81:
        break;
      case 0x83:
        RELAY1_SET(inBuff[3]);
        RELAY2_SET(inBuff[4]);
        break;
    }
  }
  buffPos = 0;
}

void sendCommand(unsigned char cmd[], int len){
  for(int i = 0; i < len; i++){
    esp.print(cmd[i]);
  }
}
