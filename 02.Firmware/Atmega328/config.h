#ifndef _CONFIG_H
#define _CONFIG_H

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

#define RELAY1_ON   digitalWrite(RELAY1, HIGH)
#define RELAY1_OFF  digitalWrite(RELAY1, LOW)
#define RELAY2_ON   digitalWrite(RELAY2, HIGH)
#define RELAY2_OFF  digitalWrite(RELAY2, LOW)

#endif
