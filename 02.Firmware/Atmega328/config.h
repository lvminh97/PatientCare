#ifndef _CONFIG_H
#define _CONFIG_H

// GPIO mapping
#define RELAY1  A1
#define RELAY2  A2

#define LCD_RS  13
#define LCD_EN  12
#define LCD_D4  11
#define LCD_D5  10
#define LCD_D6  9
#define LCD_D7  8

#define ESP_RST 4
#define ESP_CFG 5
#define ESP_TX  2
#define ESP_RX  A3

#define DHT_PIN 7
#define LM35    A0
#define SOS     3

// GPIO macro
#define RELAY1_SET(x)   digitalWrite(RELAY1, x)
#define RELAY2_SET(x)   digitalWrite(RELAY2, x)

#define ESP_RST_SET(x)    digitalWrite(ESP_RST, x)  

#define ESP_CFG_GET       digitalRead(ESP_CFG)
#define SOS_GET           digitalRead(SOS)

// Function
void gpioInit(){
  pinMode(RELAY1, OUTPUT);
  pinMode(RELAY2, OUTPUT);
  pinMode(ESP_RST, OUTPUT);
  pinMode(ESP_CFG, INPUT);

  ESP_RST_SET(1);    // ESP reset function is implemented by ext command now, so this pin is kept high
  RELAY1_SET(0);
  RELAY2_SET(0);
}

#endif
