//+------------------------------------------------------------------+
//|                                                           oi.mq5 |
//|                                                     Bogdan Guban |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Bogdan Guban"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot OI
#property indicator_label1  "OI"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#include "Cots.mqh"
Cots *cots;
//--- input parameters
input string   tool="coffee";
//--- indicator buffers
double         OIBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,OIBuffer,INDICATOR_DATA);
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
                const int &spread[])
  {
//---
  int to = rates_total - prev_calculated;
  for(int i = 0; i < to; i++){
    int idx = cots.time_to_index(time[i]);
    OIBuffer[i] = cots.oi[idx];
  }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
