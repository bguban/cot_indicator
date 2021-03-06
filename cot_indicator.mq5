//+------------------------------------------------------------------+
//|                                                          COT.mq5 |
//|                                                     Bogdan Guban |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Bogdan Guban"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 5
#property indicator_plots   5
//--- plot com_index
#property indicator_label1  "com_index"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot non_com_index
#property indicator_label2  "non_com_index"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDarkGray
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot non_rep_index
#property indicator_label3  "non_rep_index"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot com_oi_longBuffer
#property indicator_label4  "com_oi_longBuffer"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  3
//--- plot com_oi_shortBuffer
#property indicator_label5  "com_oi_shortBuffer"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  3


#include "Cots.mqh"
//--- input parameters
input int      by_weeks=52;
input string   tool="auto";
//--- indicator buffers
double         com_indexBuffer[];
double         non_com_indexBuffer[];
double         non_rep_indexBuffer[];
double         com_oi_longBuffer[];
double         com_oi_shortBuffer[];

Cots *cots;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,com_indexBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,non_com_indexBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,non_rep_indexBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,com_oi_longBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,com_oi_shortBuffer,INDICATOR_DATA);
   
   string selected_tool = tool == "auto" ? _Symbol : tool;
   
   cots = new Cots(selected_tool);
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
   int to = rates_total - prev_calculated;
   for(int i = 0; i < to; i++){
     com_indexBuffer[i] = cots.com_index(time[i], by_weeks) * 100;
     non_com_indexBuffer[i] = cots.non_com_index(time[i], by_weeks) * 100;
     non_rep_indexBuffer[i] =  cots.non_rep_index(time[i], by_weeks) * 100;
     
     com_oi_longBuffer[i] = cots.oi_index(cots.com_long, time[i], by_weeks) * 100;
     //Alert("" + cots.oi_index(cots.com_long, time[i], by_weeks) * 100);
     com_oi_shortBuffer[i] = cots.oi_index(cots.com_short, time[i], by_weeks) * 100;
   }
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
