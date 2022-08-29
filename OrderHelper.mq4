//+------------------------------------------------------------------+
//|                                                  OrderHelper.mq4 |
//|                                 Copyright 2022, Deyan Sarahoshev |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Deyan Sarahoshev"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Controls/Panel.mqh>
#include <Controls/Label.mqh>
#include <Controls/Button.mqh>
#include <Controls/Edit.mqh>

CPanel Panel;
CButton SellButton;
CButton BuyButton;

CEdit LotSizeEdit;
CEdit StopLossEdit;
CEdit TargetProfitEdit;

CLabel LotSizeLabel;
CLabel StopLossLabel;
CLabel TargetProfitLabel;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Panel.Create(0, "Panel", 0, 3, 15, 0, 0);
   Panel.BorderType(1);
   Panel.Height(110);
   Panel.Width(175);

   StopLossLabel.Create(0, "Stop Loss Label", 0, 10, 25, 0, 0);
   StopLossLabel.Text("Stop Loss in %: ");
   StopLossLabel.Color(clrWhite);
   StopLossLabel.Height(20);
   StopLossLabel.Width(75);

   StopLossEdit.Create(0, "Stop Loss Edit", 0, 135, 25, 0, 0);
   StopLossEdit.Height(20);
   StopLossEdit.Width(35);
   StopLossEdit.Text("0.5");

   TargetProfitLabel.Create(0, "Target Profit Label", 0, 10, 45, 0, 0);
   TargetProfitLabel.Text("Target Profit in %: ");
   TargetProfitLabel.Color(clrWhite);
   TargetProfitLabel.Height(20);
   TargetProfitLabel.Width(75);

   TargetProfitEdit.Create(0, "Target Profit Edit", 0, 135, 45, 0, 0);
   TargetProfitEdit.Height(20);
   TargetProfitEdit.Width(35);
   TargetProfitEdit.Text("2");

   LotSizeLabel.Create(0, "Lot Size Label", 0, 10, 65, 0, 0);
   LotSizeLabel.Text("Lot Size: ");
   LotSizeLabel.Color(clrWhite);
   LotSizeLabel.Height(20);
   LotSizeLabel.Width(75);

   LotSizeEdit.Create(0, "Lot Size Edit", 0, 135, 65, 0, 0);
   LotSizeEdit.Height(20);
   LotSizeEdit.Width(35);
   LotSizeEdit.Text("0.51");

   SellButton.Create(0, "Sell Button", 0, 10, 95, 0, 0);
   SellButton.Text("Sell");
   SellButton.Height(20);
   SellButton.Width(75);

   BuyButton.Create(0, "Buy Button", 0, 95, 95, 0, 0);
   BuyButton.Text("Buy");
   BuyButton.Height(20);
   BuyButton.Width(75);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK&&sparam=="Sell Button")
     {
      Sell();
     }

   if(id==CHARTEVENT_OBJECT_CLICK&&sparam=="Buy Button")
     {
      Buy();
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotSize()
  {
   return double(LotSizeEdit.Text());
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Risk()
  {
   return double(StopLossEdit.Text()) / 100;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TP()
  {
   return double(TargetProfitEdit.Text()) / 100;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AccountPercentStopPips(double percent, double lots)
  {
   double balance  = AccountBalance();
   double pointValue = MarketInfo(Symbol(), MODE_TICKVALUE) / MarketInfo(Symbol(), MODE_TICKSIZE);
   double stopLossPips = (balance * percent) / ((pointValue * Point) * lots);

   return (stopLossPips);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double            LongSL()
  {
   double stopLossInPoints = AccountPercentStopPips(Risk(), LotSize());
   return Bid - (stopLossInPoints * Point);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double            ShortSL()
  {
   double stopLossInPoints = AccountPercentStopPips(Risk(), LotSize());
   return Ask + (stopLossInPoints * Point);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double            LongTP()
  {
   double targetProfitInPoints = AccountPercentStopPips(TP(), LotSize());
   return (Ask + (targetProfitInPoints * Point));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double            ShortTP()
  {
   double targetProfitInPoints = AccountPercentStopPips(TP(), LotSize());
   return (Bid - (targetProfitInPoints * Point));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              Buy()
  {
   int order = OrderSend(Symbol(), OP_BUY, LotSize(), Ask, 3, LongSL(), LongTP(), "", 0, 0, Blue);
   return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              Sell()
  {
   int order = OrderSend(Symbol(), OP_SELL, LotSize(), Bid, 3, ShortSL(), ShortTP(), "", 0, 0, Red);
   return;
  }
//+------------------------------------------------------------------+
