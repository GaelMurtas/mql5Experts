//+------------------------------------------------------------------+
//|                                     MACDlowCrossoverUpgraded.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <trade/trade.mqh>

                         enum EXIT_ENUM
                            {
                               SLTP,
                               TRAILING_STOP,
                               MACD
                            };

// Inputs
                         input group               "██████████          MACDLowCrossover          ██████████";
                         input group               "██████████          Version Upgraded           ᅠ██████████";
                         input group               "███        Author : @GaelMurtas & @FlorianPascual        ███";
                         input group               "██████           Company : Quenya SAS           ██████";
                         input group                                       " - RISK";
                         input double Lots = 0.1;                          // Trade lot size
                         input double RRR = 3.0;                           // Risk Reward Ratio
                         input double BE = 1.0;                            // Break Even Point
                         input double mult = 2.0;                          // Risk size multiplier
                         input group                                       " - TIMEFRAME";
                         input ENUM_TIMEFRAMES tf1 = PERIOD_D1;            // Timeframe 1 (Daily)
                         input ENUM_TIMEFRAMES tf2 = PERIOD_H4;            // Timeframe 2 (4 Hours)
                         input ENUM_TIMEFRAMES tf3 = PERIOD_H1;            // Timeframe 3 (1 Hour)
                         input group                                       " - MACD";
                         input uint macdLongLen = 26;                      // MACD long period length
                         input uint macdShortLen = 12;                     // MACD short period length
                         input uint macdSignalLen = 9;                     // MACD signal line length
                         input bool macdLowCrossOnly = true;               // Use low crossover only for MACD
                         input group                                       " - MOVING AVERAGES";
                         input uint maShortPeriod = 20;                    // Short MA period
                         input bool maShortEma = false;                    // Use EMA for short MA
                         input uint maLongPeriod = 50;                     // Long MA period
                         input uint maStructPeriod = 200;                  // Structural MA period
                         input group                                       " - RSI";
                         input bool rsiCondition = true;                   // Use RSI condition
                         input uint rsiPeriod = 14;                        // RSI period length
                         input uint rsiLo = 60;                            // Lower RSI threshold
                         input uint rsiHi = 80;                            // Upper RSI threshold
                         input group                                       " - MONEY MANAGEMENT";
                         input bool dontaccepttheloss = false;             // Do we accept the loss ?
                         input group                                       " - EXIT STRATEGY";
                         input bool breakeven = false;                     // Break Even ?
                         input EXIT_ENUM = SLTP                            // Exit strategy choice
                         input group                                       " - MISC";
                         input uint maVolumePeriod = 10;                   // Volume MA period
                         input uint macdEntryTime = 3;                     // MACD entry window (candles)
                         input bool maConjoncturelCondition = true;        // Use conjunctural trend condition
                         input bool maStructurelleCondition = true;        // Use structural trend condition
                         input bool patternCondition = true;               // Use pattern condition

                         // Global Variables
                         CTrade trade;                                     // Trade object
                         int handleMACD;                                   // MACD indicator handle
                         int handleAtr;                                    // ATR indicator handle
                         int handleVolume;                                 // Volume indicator handle
                         int handleMA1;                                    // Short MA handle
                         int handleMA2;                                    // Long MA handle
                         int handleMA3;                                    // Structural MA handle
                         int handleRSI;                                    // RSI indicator handle
                         int totalBars = iBars(NULL, tf2);                 // Total bars in tf2 timeframe
                         bool position = false;                            // Is there an open position?
                         bool achat = false;                               // Buy entry reason
                         bool vente = false;                               // Sell entry reason

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("Init Success");
   
   handleMACD = iCustom(_Symbol,tf2, "TrueMACD.ex5", macdLongLen, macdShortLen, macdSignalLen);
   if(maShortEma) handleMA1 = iMA(_Symbol,tf1,maShortPeriod,0,MODE_EMA,PRICE_CLOSE);
   else handleMA1 = iMA(_Symbol,tf1,maShortPeriod,0,MODE_SMA,PRICE_CLOSE);
   handleMA2 = iMA(_Symbol,tf1,maLongPeriod,0,MODE_SMA,PRICE_CLOSE);
   handleMA3 = iMA(_Symbol,tf1,maStructPeriod,0,MODE_SMA,PRICE_CLOSE);
   handleRSI = iRSI(_Symbol,tf1,rsiPeriod,PRICE_CLOSE);
   handleAtr = iATR(_Symbol,tf2,20);
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }

// Helper function to copy buffers
void CopyBuffers(uint barsToCopy, double &macdSignal[], double &macdHisto[], double &maShort[], double &maLong[], double &maStruct[], double &rsi[], double &atr[])
{
    CopyBuffer(handleMACD, 1, 1, barsToCopy, macdSignal);
    CopyBuffer(handleMACD, 2, 1, barsToCopy, macdHisto);
    CopyBuffer(handleMA1, 0, 1, 1, maShort);
    CopyBuffer(handleMA2, 0, 1, 1, maLong);
    CopyBuffer(handleMA3, 0, 1, 1, maStruct);
    CopyBuffer(handleRSI, 0, 1, 1, rsi);
    CopyBuffer(handleAtr, 0, 1, 1, atr);
}

// Helper function to check MACD condition
bool CheckMACDCondition(double& macdHisto[], double &macdSignal[])
{
    for (uint i = 0; i < macdEntryTime; i++) {
        bool candlesAreGreen = true;
        bool histoTurnGreen = (macdHisto[3 + i] > 0) && (macdHisto[2 + i] < 0) && (macdHisto[1 + i] < 0) && (macdHisto[0 + i] < 0);
        bool negativeLine = (!macdLowCrossOnly) || (macdSignal[0 + i] < 0 && macdSignal[1 + i] < 0 && macdSignal[2 + i] < 0);

        if (histoTurnGreen && negativeLine) {
            for (uint j = i + 1; j < macdEntryTime; j++) {
                candlesAreGreen = candlesAreGreen && (macdHisto[3 + j] > macdHisto[3 + j - 1]);
            }
            if (candlesAreGreen) {
                return true;
            }
        }
    }
    return false;
}

// Helper function to check pattern condition
bool CheckPatternCondition()
{
    bool patternCondVerifier = false;
    uint lag = 1;

    while (iClose(_Symbol, tf3, lag) > iOpen(_Symbol, tf3, lag)) {
        bool redCandle = iClose(_Symbol, tf3, lag + 1) < iOpen(_Symbol, tf3, lag + 1);
        patternCondVerifier = redCandle && (iClose(_Symbol, tf3, lag) > iOpen(_Symbol, tf3, lag + 1));
        patternCondVerifier = patternCondVerifier || (((iHigh(_Symbol, tf3, lag) - iLow(_Symbol, tf3, lag)) / (iHigh(_Symbol, tf3, lag) - iOpen(_Symbol, tf3, lag))) > 3);

        if (patternCondVerifier) {
            break;
        }

        lag++;
    }

    return patternCondVerifier || !patternCondition;
}

// Helper function for money management
void tpsl_calculation(double entry, double &sl, double &tp, double &atr[])
{
    sl = entry - mult * atr[0] - (entry - iLow(_Symbol, tf2, 1));
    tp = entry + mult * RRR * atr[0];
}

// Helper function to check entry conditions
bool CheckEntryConditions(double &macdHisto[], double &macdSignal[], double &maShort[], double &maLong[], double &maStruct[], double &rsi[])
{
    bool rsiCond = (!rsiCondition) || ((rsi[0] >= rsiLo) && (rsi[0] <= rsiHi));
    bool conjoncturelCondition = (!maConjoncturelCondition) || (maShort[0] > maLong[0]);
    bool structurelCondition = (!maStructurelleCondition) || (maLong[0] > maStruct[0]);
    bool trendCondition = rsiCond && conjoncturelCondition && structurelCondition;
    bool macdCond = CheckMACDCondition(macdHisto, macdSignal);
    bool patternCondVerifier = CheckPatternCondition();

    return patternCondVerifier && macdCond && trendCondition;
}

// Helper function to check exit conditions
void CheckExitConditions()
{
    if (!PositionSelect(_Symbol)) {
        position = false;
    }
}

// Expert tick function
void OnTick()
{
    int bars = iBars(_Symbol, tf3);
    if (bars <= totalBars)
        return;

    totalBars = bars;
    uint barsToCopy = 4 + macdEntryTime - 1;
    double macdSignal[], macdHisto[], maShort[1], maLong[1], maStruct[1], rsi[1], atr[1];

    CopyBuffers(barsToCopy, macdSignal, macdHisto, maShort, maLong, maStruct, rsi, atr);

    bool conditionAchat = CheckEntryConditions(macdHisto, macdSignal, maShort, maLong, maStruct, rsi);

    if (conditionAchat && !position) {
        position = true;
        double entry = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
        double tp, sl;
        tpsl_calculation(entry, sl, tp, atr);
        trade.Buy(Lots, NULL, entry, sl, tp, "Achat");
    }

    CheckExitConditions();
}