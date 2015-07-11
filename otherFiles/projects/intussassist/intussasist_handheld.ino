/***************************************************
Code for Intussassception Reduction Device Handheld Remote.

Written by Michael Sobrepera
copyright 2015 Michael Sobrepera
mjsobrep@live.com
 ****************************************************/

// This Teensy3 native optimized version requires specific pins
#define sclk 13  // SCLK can also use pin 14
#define mosi 11  // MOSI can also use pin 7
#define cs   10  // CS & DC can use pins 2, 6, 9, 10, 15, 20, 21, 22, 23
#define dc   9   //  but certain pairs must NOT be used: 2+10, 6+9, 20+23, 21+22
#define rst  8   // RST can use any pin
#define sdcs 12   // CS for SD card, can use any pin
#define START 4
#define STOP 3
#define PUP 23
#define PDOWN 17 //3
#define STARTCOM 0x1
#define STOPCOM 0x2
#define PUPCOM 0x3
#define PDOWNCOM 0x4

#include <Adafruit_GFX.h>    // Core graphics library
#include <Adafruit_ST7735.h> // Hardware-specific library
#include <SPI.h>
#include <math.h>

#if defined(__SAM3X8E__)
#undef __FlashStringHelper::F(string_literal)
#define F(string_literal) string_literal
#endif

// Option 1: use any pins but a little slower
//Adafruit_ST7735 tft = Adafruit_ST7735(cs, dc, mosi, sclk, rst);

// Option 2: must use the hardware SPI pins
// (for UNO thats sclk = 13 and sid = 11) and pin 10 must be
// an output. This is much faster - also required if you want
// to use the microSD card (see the image drawing example)
Adafruit_ST7735 tft = Adafruit_ST7735(cs, dc, rst);
float p = 3.1415926;

//GLOBAL VARS
int setP = NAN;
int actP = NAN;
int drawnSetP = NAN;
int drawnActP = NAN;

unsigned long latchstart = millis();
unsigned long latchstop = millis();
unsigned long latchpup = millis();
unsigned long latchpdown = millis();

bool runningV = false;
bool runningDraw = false;


//FUNCTION TO DRAW BORDER
void drawBorder(uint16_t color) {
  tft.drawFastHLine(0, 0, 128, color);
  tft.drawFastHLine(0, 159, 128, color);
  tft.drawFastVLine(0, 0, 160, color);
  tft.drawFastVLine(127, 0, 160, color);
}


void setup(void) {
  pinMode(sdcs, INPUT_PULLUP);  // don't touch the SD card
  Serial.begin(9600);
//  Serial.print("hello!");

  // Our supplier changed the 1.8" display slightly after Jan 10, 2012
  // so that the alignment of the TFT had to be shifted by a few pixels
  // this just means the init code is slightly different. Check the
  // color of the tab to see which init code to try. If the display is
  // cut off or has extra 'random' pixels on the top & left, try the
  // other option!
  // If you are seeing red and green color inversion, use Black Tab

  // If your TFT's plastic wrap has a Black Tab, use the following:
  tft.initR(INITR_BLACKTAB);   // initialize a ST7735S chip, black tab
  // If your TFT's plastic wrap has a Red Tab, use the following:
  //tft.initR(INITR_REDTAB);   // initialize a ST7735R chip, red tab
  // If your TFT's plastic wrap has a Green Tab, use the following:
  //tft.initR(INITR_GREENTAB); // initialize a ST7735R chip, green tab

//  Serial.println("init");

  uint16_t time = millis();
  time = millis() - time;
//  Serial.println("done");

  //DRAW BASICS
  //background
  tft.fillScreen(ST7735_BLACK);
  
  //centerline
  tft.drawFastHLine(0, 79, 128, ST7735_WHITE);
  tft.drawFastHLine(0, 80, 128, ST7735_WHITE);
  tft.setTextWrap(false);

  //set pressure
  char toPrint[8] = "Set P:";
  tft.setTextColor(ST7735_RED);
  tft.setTextSize(1);
  tft.setCursor(4, 2);
  tft.println(toPrint);

  //actual pressure
  char toPrint1[20] = "Actual P:";
  tft.setTextColor(ST7735_RED);
  tft.setTextSize(1);
  tft.setCursor(4, 84);
  tft.println(toPrint1);

  //mmHg
  char toPrint2[20] = "mmHg";
  tft.setTextColor(ST7735_RED);
  tft.setTextSize(1);
  tft.setCursor(100, 70);
  tft.println(toPrint2);
  tft.setCursor(100, 150);
  tft.println(toPrint2);

  //border
  drawBorder(ST7735_MAGENTA);


  //set up inputs
  //other buttons fail to off
  pinMode(START, INPUT_PULLUP);
  pinMode(STOP, INPUT_PULLUP);
  pinMode(PUP, INPUT_PULLUP);
  pinMode(PDOWN, INPUT_PULLUP);


  
}

void loop() {
  //INCOMING SERIAL DATA
  while(Serial.available()>1){
    byte byte1 = Serial.read();
    byte byte2 = Serial.read();
    int control = (byte1&0xF0)>>4;
    int val = ((byte1&0x0F)<<8)+byte2;
    if(control==1){
      actP=val;
    }
    if(control==2){
      setP=val;
    }
    if(control==3){
      runningV=false;
    }
    if(control==4){
      runningV=true;
    }
  }
  
  
  //STOP BUTTON
  if (digitalRead(STOP) == LOW && (millis()-300)>latchstop) {
    //Serial.println("stop");
    Serial.write(STOPCOM);
    latchstop = millis();
  }

  //PRESSURE DOWN BUTTON
  if (digitalRead(START) == LOW && (millis()-300)>latchstart) {
    Serial.write(STARTCOM);
    latchstart = millis();
  }

  //PRESSURE UP BUTTON
  if (digitalRead(PUP) == LOW && (millis()-300)>latchpup) {
    Serial.write(PUPCOM);
    latchpup = millis();
  }

  //START BUTTON
  if (digitalRead(PDOWN) == LOW && (millis()-300)>latchpdown) {
    Serial.write(PDOWNCOM);
    latchpdown = millis();
  }

  //REDRAW SET P
  if (setP != drawnSetP) {
    char toPrint[3];
    sprintf(toPrint, "%.3i", setP);
    tft.fillRect(2, 15 , 122, 56, ST7735_BLACK);
    tft.setTextColor(ST7735_BLUE);
    drawnSetP = setP;
    tft.setTextSize(7);
    tft.setCursor(4, 15);
    tft.println(toPrint);
  }

  //REDRAW ACT P
  if (actP != drawnActP) {
    char toPrint[3];
    sprintf(toPrint, "%.3i", actP);
    tft.fillRect(2, 95 , 122, 56, ST7735_BLACK);
    tft.setTextColor(ST7735_BLUE);
    drawnActP = actP;
    tft.setTextSize(7);
    tft.setCursor(4, 95);
    tft.println(toPrint);
  }

  //REDRAW BORDER
  if (runningV != runningDraw) {
    if (runningV) {
      drawBorder(ST7735_GREEN);
    }
    else {
      drawBorder(ST7735_MAGENTA);
    }
    runningDraw = runningV;
  }
}
