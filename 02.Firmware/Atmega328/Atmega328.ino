#include "config.h"
#include <LiquidCrystal.h>
#include <SoftwareSerial.h>
#include <Wire.h>
#include <MAX30100_PulseOximeter.h>
#include <DHT.h>

#define DEBUG false

SoftwareSerial esp(ESP_TX, ESP_RX);
LiquidCrystal LCD(LCD_RS, LCD_EN, LCD_D4, LCD_D5, LCD_D6, LCD_D7);
PulseOximeter  pox;
DHT dht(DHT_PIN, DHT11);

unsigned long timer_5ms, timer_1s = 0, timer_5s = 0;
int sosbtn_cnt = 0, cfgbtn_cnt = 0;
unsigned char sos_status = 0, cur_disp = 0;
unsigned char is_config_mode = 0, wifi_status = 0, lcd_update = 0;

int heart, spo2, body_temp, temp, humi;

unsigned char inBuff[40], outBuff[40] = {0x84, 0xF0};
int buffPos = 0;

void setup(){
#if DEBUG
  Serial.begin(115200);
#endif
  gpioInit();
  
  LCD.begin(16, 2);
  LCD.print("Patient Care");
  
  pox.begin();
  delay(1000);
  
  dht.begin();
  
  esp.begin(9600);
  // Reset ESP
  outBuff[2] = 0x80;
  outBuff[3] = 0x83;
  sendCommand(outBuff, 4);
  delay(500);   // wait 500ms
  // ESP connect to WiFi
  wifi_status = 0xFF;
  outBuff[2] = 0x80;
  outBuff[3] = 0x85;
  sendCommand(outBuff, 4);
  
  lcd_update = 1;
}

void loop(){
  checkReceiveCommand();
  if(is_config_mode == 0){
    pox.update();
  }
  // 5ms tasks
  if(millis() - timer_5ms >= 5){
    checkSOSBtn();
    checkCfgBtn();
    lcdDisplay();
    timer_5ms = millis();
  }
  // 1s tasks
  if(millis() - timer_1s >= 1000){
    if(is_config_mode == 0){
      updateHeartRateSpO2();
      updateBodyTemp();
    }
    timer_1s = millis();
  }
  // 5s tasks
  if(millis() - timer_5s >= 5000){
    if(is_config_mode == 0)
      updateTempHumi();
    timer_5s = millis();
  }
}

void updateHeartRateSpO2(){
  heart = pox.getHeartRate();
  spo2 = pox.getSpO2();

  if(heart < 50 || spo2 > 100){
    heart = 0;
    spo2 = 0;
  }
  
  if(cur_disp == 1)
    lcd_update = 1;
    
  if(wifi_status == 0x03 && is_config_mode == 0){
    outBuff[2] = 0x82;
    outBuff[3] = 0x82;
    outBuff[4] = (heart >> 8) & 0xFF;
    outBuff[5] = heart & 0xFF;
    outBuff[6] = spo2;
    sendCommand(outBuff, 7);
  }
}

void updateTempHumi(){
  temp = dht.readTemperature();
  humi = dht.readHumidity();
  if(cur_disp == 0)
    lcd_update = 1;
    
  if(wifi_status == 0x03 && is_config_mode == 0){
    outBuff[2] = 0x82;
    outBuff[3] = 0x81;
    outBuff[4] = temp;
    outBuff[5] = humi;
    sendCommand(outBuff, 6);
  }
}

void updateBodyTemp(){
  body_temp = analogRead(LM35) / 1023.0 * 500;
  if(cur_disp == 0)
    lcd_update = 1;

  if(wifi_status == 0x03 && is_config_mode == 0){
    outBuff[2] = 0x82;
    outBuff[3] = 0x84;
    outBuff[4] = body_temp;
    sendCommand(outBuff, 5);
  }
}

void lcdDisplay(){
  if(lcd_update == 0)
    return;
  else
    lcd_update = 0;

  if(wifi_status == 0xFF){
    LCD.clear();
    LCD.print("WiFi connecting");
  }
  else if(is_config_mode == 1){
    LCD.clear();
    LCD.print("Config mode");
  }
  else{
    if(cur_disp == 0){
      LCD.setCursor(0, 0);
      LCD.print("T: ");
      LCD.print(temp);
      LCD.print("oC H: ");
      LCD.print(humi);
      LCD.print("%     ");
      LCD.setCursor(0, 1);
      LCD.print("Body temp: ");
      LCD.print(body_temp);
      LCD.print("oC     ");
    }
    else if(cur_disp == 1){
      LCD.setCursor(0, 0);
      LCD.print("Heart: ");
      LCD.print(heart);
      LCD.print("bpm       ");
      LCD.setCursor(0, 1);
      LCD.print("SpO2: ");
      LCD.print(spo2);
      LCD.print("%         ");
    }
  }
}

void checkSOSBtn(){
  if(SOS_GET == LOW){
    if(sosbtn_cnt < 400){
      sosbtn_cnt++;
      if(sosbtn_cnt == 400){ // press and hold the SOS button in 2s
        sos_status = !sos_status;
        if(wifi_status == 0x03 && is_config_mode == 0){
          // send the SOS status to ESP
          outBuff[2] = 0x82;
          outBuff[3] = 0x83;
          outBuff[4] = sos_status;
          sendCommand(outBuff, 5);
        }
      }
    }
  }
  else{
    sosbtn_cnt = 0;
  }
}

void checkCfgBtn(){
  if(ESP_CFG_GET == LOW){
    if(cfgbtn_cnt < 400){
      cfgbtn_cnt++;
      if(cfgbtn_cnt == 20){    // switch info displayed in LCD
        cur_disp = (cur_disp + 1) % 2;
      }
      else if(cfgbtn_cnt == 400){    // enter ESP config mode
        is_config_mode = !is_config_mode;
        lcd_update = 1;
        outBuff[2] = 0x80;
        outBuff[3] = is_config_mode ? 0x81 : 0x82;
        sendCommand(outBuff, 4);
      }
    }
  }
  else{
    cfgbtn_cnt = 0;
  }
}

void checkReceiveCommand(){
  unsigned char c;
  if(esp.available()){
    while(esp.available()){
      c = (unsigned char) esp.read();
      if(c == 0xF0 && buffPos > 1 && inBuff[buffPos - 1] == 0x84){
        inBuff[0] = 0x84;
        inBuff[1] = 0xF0;
        buffPos = 2;
      }
      else if(c == 0xF1 && buffPos > 3 && inBuff[buffPos - 1] == 0x84){
        processCommand();
        buffPos = 0;
      }
      else{
        inBuff[buffPos++] = c;
      }
    }
  }
}

void processCommand(){
#if DEBUG
  Serial.print("Receive: ");
  for(int i = 0; i < buffPos; i++){
    Serial.print(inBuff[i], HEX);
    Serial.print(" ");
  }
  Serial.println();
#endif
  if(inBuff[0] == 0x84 && inBuff[1] == 0xF0){
    switch(inBuff[2]){
      case 0x81:
        if(inBuff[3] == 0x82){    // ESP finish config mode
          is_config_mode = 0;     // exit from config mode
          // Reset ESP
          outBuff[2] = 0x80;
          outBuff[3] = 0x83;
          sendCommand(outBuff, 4);
          delay(500);   // wait 500ms
          // ESP connect to WiFi
          wifi_status = 0xFF;
          outBuff[2] = 0x80;
          outBuff[3] = 0x85;
          sendCommand(outBuff, 4);
          lcd_update = 1;
        }
        else if(inBuff[3] == 0x84){ // get WiFi status from ESP
          wifi_status = inBuff[4];
          if(wifi_status != 0xFF)
            lcd_update = 1;
        }
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
#if DEBUG
  Serial.print("Send: ");
  for(int i = 0; i < len; i++){
    Serial.print(cmd[i], HEX);
    Serial.print(" ");
  }
  Serial.println();
#endif
  for(int i = 0; i < len; i++){
    esp.print((char) cmd[i]);
  }
  esp.print((char) 0x84);
  esp.print((char) 0xF1);
}
