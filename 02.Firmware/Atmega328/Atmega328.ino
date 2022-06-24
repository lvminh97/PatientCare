#include "config.h"
#include <LiquidCrystal.h>
#include <Wire.h>
#include <MAX30100_PulseOximeter.h>

LiquidCrystal LCD(LCD_RS, LCD_EN, LCD_D4, LCD_D5, LCD_D6, LCD_D7);
PulseOximeter  pox;

void setup(){
  Serial.begin(9600);
  LCD.begin(16, 2);
  LCD.print("Patient Care");
  delay(4000);
  pinMode(RELAY2, OUTPUT);
  digitalWrite(RELAY2, HIGH);
  pox.begin();
}

unsigned long ts = 0;

void loop(){
  pox.update();
  if(millis() - ts > 1000){
    LCD.clear();
    LCD.setCursor(0, 0);
    LCD.print("H:");
    LCD.print(int(pox.getHeartRate()));
    LCD.print(" ");
    LCD.print("SpO2:");
    LCD.print(int(pox.getSpO2()));
    ts = millis();
  }
  delay(1);
}
