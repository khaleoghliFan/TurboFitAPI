//+------------------------------------------------------------------+
//| Expert advisor: RSI Sell on Overbought                          |
//| شرط: اگر RSI در 14 کندل اخیر همگی بالای 70 باشند → فروش         |
//+------------------------------------------------------------------+
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

input int rsiPeriod = 14;
input double lotSize = 0.1;

int rsiHandle;
double rsiVals[];

//+------------------------------------------------------------------+
//| initialize                                                 |
//+------------------------------------------------------------------+
int OnInit()
  {
   rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, rsiPeriod, PRICE_CLOSE);
   if(rsiHandle == INVALID_HANDLE)
     {
      Print("❌ خطا در ساخت RSI Handle");
      return INIT_FAILED;
     }
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| تابع اصلی برای هر تیک                                           |
//+------------------------------------------------------------------+
void OnTick()
  {

   string signal;
   double bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
   double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);
   double MyRsiarrays[];
   //Print("Bid = ", bid, " | Ask = ", ask);
   int myRsiDefination =iRSI(_Symbol,_Period,14,PRICE_CLOSE);
   ArraySetAsSeries(MyRsiarrays,true);
   CopyBuffer(myRsiDefination,0,0,3,MyRsiarrays);
   double myRsivalue = NormalizeDouble(MyRsiarrays[0],2);
   if (myRsivalue>70) signal="sell";
   if (myRsivalue<30) signal= "buy";
   if (signal=="buy" && PositionsTotal()<1)
   {trade.Buy(0.10,NULL,ask,0,(ask-150*_Point),NULL);}
    if (signal=="sell" && PositionsTotal()<1)
   {trade.Sell(0.10,NULL,bid,0,(bid-150*_Point),NULL);}

   //create chart output
   Comment("the current signal is:", signal);
  }



