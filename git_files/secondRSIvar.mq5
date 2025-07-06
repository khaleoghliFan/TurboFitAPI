//+------------------------------------------------------------------+
//| Expert advisor: RSI Sell on Overbought                          |
//+------------------------------------------------------------------+
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

input int    rsiPeriod     = 14;
input double lotSize       = 0.1;
input double overbought    = 70.0;
input double oversold      = 30.0;
input int    rsiLookback   = 14;

int rsiHandle;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, rsiPeriod, PRICE_CLOSE);
   if(rsiHandle == INVALID_HANDLE)
     {
      Print("Error creating RSI handle");
      return INIT_FAILED;
     }
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double bid, ask;

   if(!SymbolInfoDouble(_Symbol, SYMBOL_BID, bid) ||
      !SymbolInfoDouble(_Symbol, SYMBOL_ASK, ask))
     {
      Print("Error retrieving Bid or Ask prices");
      return;
     }

   bid = NormalizeDouble(bid, _Digits);
   ask = NormalizeDouble(ask, _Digits);

   double MyRsiarrays[];
   ArraySetAsSeries(MyRsiarrays, true);

   if(CopyBuffer(rsiHandle, 0, 0, rsiLookback, MyRsiarrays) <= 0)
     {
      Print("Error in CopyBuffer");
      return;
     }

   bool allAboveOverbought = true;
   bool allBelowOversold = true;

   for(int i = 0; i < rsiLookback; i++)
     {
      if(MyRsiarrays[i] <= overbought)
         allAboveOverbought = false;

      if(MyRsiarrays[i] >= oversold)
         allBelowOversold = false;
     }

   string signal = "";

   if(allAboveOverbought)
      signal = "sell";
   else if(allBelowOversold)
      signal = "buy";

   if(signal == "buy" && PositionsTotal() < 1)
     {
      if(trade.Buy(lotSize, NULL, ask, 0, ask - 150 * _Point, NULL))
         Print("Opened BUY position");
      else
         Print("Error opening BUY position: ", GetLastError());
     }
   else if(signal == "sell" && PositionsTotal() < 1)
     {
      if(trade.Sell(lotSize, NULL, bid, 0, bid - 150 * _Point, NULL))
         Print("Opened SELL position");
      else
         Print("Error opening SELL position: ", GetLastError());
     }

   Comment("Signal: ", signal,
           "\nRSI[0] = ", NormalizeDouble(MyRsiarrays[0], 2),
           "\nBid = ", bid,
           "\nAsk = ", ask);
  }
