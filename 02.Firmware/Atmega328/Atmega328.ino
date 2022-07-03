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

unsigned long timer1 = 0, timer2 = 0;
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
}

void loop(){
  checkReceiveCommand();
  pox.update();
  if(millis() - timer1 > 1000){
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
    timer1 = millis();
  }
  if(millis() - timer2 > 5000){
    temp = dht.readTemperature();
    humi = dht.readHumidity();
    outBuff[2] = 0x82;
    outBuff[3] = 0x81;
    outBuff[4] = temp;
    outBuff[5] = humi;
    sendCommand(outBuff, 6);
    timer2 = millis();
  }
  delay(1);
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

void sendCommand(char cmd[], int len){
  for(int i = 0; i < len; i++){
    esp.print(cmd[i]);
  }
}
