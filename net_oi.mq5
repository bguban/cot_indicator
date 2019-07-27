//+------------------------------------------------------------------+
//|                                                    com_in_oi.mq5 |
//|                                                     Bogdan Guban |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Bogdan Guban"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum -50
#property indicator_maximum 50
#property indicator_buffers 1
#property indicator_plots   1
//--- plot com_in_oi
#property indicator_label1  "com_long_in_oi"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#include "Cots.mqh"
//--- input parameters
input string  tool="coffee";

//--- indicator buffers
double         com_in_oiBuffer[];
Cots *cots;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,com_in_oiBuffer,INDICATOR_DATA);
   cots = new Cots(tool);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
  
  int to = rates_total - prev_calculated;
  for(int i = 0; i < to; i++){
    int idx = cots.time_to_index(time[i]);
    com_in_oiBuffer[i] = (double)(cots.com_long[idx] - cots.com_short[idx])  / cots.oi[idx] * 100;
  }
  
  return(rates_total);
}
//+------------------------------------------------------------------+
