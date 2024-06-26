//+------------------------------------------------------------------+
//|                                     MACDlowCrossoverUpgraded.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <trade/trade.mqh>

/*

Break Even exit : Déclencher à un certain seuil de risque (1R-2R etc). R = mult * ATR (1 classique - 2 crypto) Taille stop loss
Parrallelisation : 1 config sur plusieurs symboles. Plusieurs configs, plusieurs symboles = mieux. = Mieux, à faire
Force close = A faire
Gestion des lots dynamique en fonction du capital et de l'ATR. Le % risque doit être fixe.

*/

// Inputs
                        input group               "██████████          MACDLowCrossover          ██████████";
                        input group               "██████████          Version Upgraded           ᅠ██████████";
                        input group               "███        Author : @GaelMurtas & @FlorianPascual        ███";
                        input group               "██████           Company : Quenya SAS           ██████";
                        input group                                       "";
                        input group                                       " - MONEY MANAGEMENT";
                        input int    ForceClose = 10;                     // Force Close value. 0 = disable.
                        
                        input group                                       "";
                        input group                                       " ------ FOREX";
                        input group                                       "";
                        input group                                       " - MARKETS";
                        input string forex_Market = "XAUUSD";             // Forex market symbol
                        
                        input group                                       " - RISK";
                        input double forex_Lots = 0.1;                    // Trade lot size
                        input double forex_RRR = 3.0;                     // Risk Reward Ratio
                        input double forex_BE = 1.0;                      // Break Even Point
                        input double forex_mult = 2.0;                    // Risk size multiplier
                        
                        input group                                       " - TIMEFRAME";
                        input ENUM_TIMEFRAMES forex_tf1 = PERIOD_D1;      // Timeframe 1 (Daily)
                        input ENUM_TIMEFRAMES forex_tf2 = PERIOD_H4;      // Timeframe 2 (4 Hours)
                        input ENUM_TIMEFRAMES forex_tf3 = PERIOD_H1;      // Timeframe 3 (1 Hour)
                        
                        input group                                       " - MACD";
                        input uint forex_macdLongLen = 26;                // MACD long period length
                        input uint forex_macdShortLen = 12;               // MACD short period length
                        input uint forex_macdSignalLen = 9;               // MACD signal line length
                        input bool forex_macdLowCrossOnly = true;         // Use low crossover only for MACD
                        
                        input group                                       " - MOVING AVERAGES";
                        input uint forex_maShortPeriod = 20;              // Short MA period
                        input bool forex_maShortEma = false;              // Use EMA for short MA
                        input uint forex_maLongPeriod = 50;               // Long MA period
                        input uint forex_maStructPeriod = 200;            // Structural MA period
                        
                        input group                                       " - RSI";
                        input bool forex_rsiCondition = true;             // Use RSI condition
                        input uint forex_rsiPeriod = 14;                  // RSI period length
                        input uint forex_rsiLo = 60;                      // Lower RSI threshold
                        input uint forex_rsiHi = 80;                      // Upper RSI threshold
                        
                        input group                                       " - MISC";
                        input uint forex_maVolumePeriod = 10;             // Volume MA period
                        input uint forex_macdEntryTime = 3;               // MACD entry window (candles)
                        input bool forex_maConjoncturelCondition = true;  // Use conjunctural trend condition
                        input bool forex_maStructurelleCondition = true;  // Use structural trend condition
                        input bool forex_patternCondition = true;         // Use pattern condition
                        
                        input group                                       "";
                        input group                                       " ------ CRYPTO";
                        input group                                       "";
                        input group                                       " - MARKETS";
                        input string crypto_Market = "BTCUSD";            // Crypto market symbol
                        
                        input group                                       " - RISK";
                        input double crypto_Lots = 0.1;                   // Trade lot size
                        input double crypto_RRR = 3.0;                    // Risk Reward Ratio
                        input double crypto_BE = 1.0;                     // Break Even Point
                        input double crypto_mult = 2.0;                   // Risk size multiplier
                        
                        input group                                       " - TIMEFRAME";
                        input ENUM_TIMEFRAMES crypto_tf1 = PERIOD_D1;     // Timeframe 1 (Daily)
                        input ENUM_TIMEFRAMES crypto_tf2 = PERIOD_H4;     // Timeframe 2 (4 Hours)
                        input ENUM_TIMEFRAMES crypto_tf3 = PERIOD_H1;     // Timeframe 3 (1 Hour)
                        
                        input group                                       " - MACD";
                        input uint crypto_macdLongLen = 26;               // MACD long period length
                        input uint crypto_macdShortLen = 12;              // MACD short period length
                        input uint crypto_macdSignalLen = 9;              // MACD signal line length
                        input bool crypto_macdLowCrossOnly = true;        // Use low crossover only for MACD
                        
                        input group                                       " - MOVING AVERAGES";
                        input uint crypto_maShortPeriod = 20;             // Short MA period
                        input bool crypto_maShortEma = false;             // Use EMA for short MA
                        input uint crypto_maLongPeriod = 50;              // Long MA period
                        input uint crypto_maStructPeriod = 200;           // Structural MA period
                        
                        input group                                       " - RSI";
                        input bool crypto_rsiCondition = true;            // Use RSI condition
                        input uint crypto_rsiPeriod = 14;                 // RSI period length
                        input uint crypto_rsiLo = 60;                     // Lower RSI threshold
                        input uint crypto_rsiHi = 80;                     // Upper RSI threshold
                        
                        input group                                       " - MISC";
                        input uint crypto_maVolumePeriod = 10;            // Volume MA period
                        input uint crypto_macdEntryTime = 3;              // MACD entry window (candles)
                        input bool crypto_maConjoncturelCondition = true; // Use conjunctural trend condition
                        input bool crypto_maStructurelleCondition = true; // Use structural trend condition
                        input bool crypto_patternCondition = true;        // Use pattern condition
                        
                        input group                                       "";
                        input group                                       " ------ OTHER";
                        input group                                       "";
                        input group                                       " - MARKETS";
                        input string other_Market = "";                   // Other market symbol
                        
                        input group                                       " - RISK";
                        input double other_Lots = 0.1;                    // Trade lot size
                        input double other_RRR = 3.0;                     // Risk Reward Ratio
                        input double other_BE = 1.0;                      // Break Even Point
                        input double other_mult = 2.0;                    // Risk size multiplier
                        
                        input group                                       " - TIMEFRAME";
                        input ENUM_TIMEFRAMES other_tf1 = PERIOD_D1;      // Timeframe 1 (Daily)
                        input ENUM_TIMEFRAMES other_tf2 = PERIOD_H4;      // Timeframe 2 (4 Hours)
                        input ENUM_TIMEFRAMES other_tf3 = PERIOD_H1;      // Timeframe 3 (1 Hour)
                        
                        input group                                       " - MACD";
                        input uint other_macdLongLen = 26;                // MACD long period length
                        input uint other_macdShortLen = 12;               // MACD short period length
                        input uint other_macdSignalLen = 9;               // MACD signal line length
                        input bool other_macdLowCrossOnly = true;         // Use low crossover only for MACD
                        
                        input group                                       " - MOVING AVERAGES";
                        input uint other_maShortPeriod = 20;              // Short MA period
                        input bool other_maShortEma = false;              // Use EMA for short MA
                        input uint other_maLongPeriod = 50;               // Long MA period
                        input uint other_maStructPeriod = 200;            // Structural MA period
                        
                        input group                                       " - RSI";
                        input bool other_rsiCondition = true;             // Use RSI condition
                        input uint other_rsiPeriod = 14;                  // RSI period length
                        input uint other_rsiLo = 60;                      // Lower RSI threshold
                        input uint other_rsiHi = 80;                      // Upper RSI threshold
                        
                        input group                                       " - MISC";
                        input uint other_maVolumePeriod = 10;             // Volume MA period
                        input uint other_macdEntryTime = 3;               // MACD entry window (candles)
                        input bool other_maConjoncturelCondition = true;  // Use conjunctural trend condition
                        input bool other_maStructurelleCondition = true;  // Use structural trend condition
                        input bool other_patternCondition = true;         // Use pattern condition


                         // Global Variables
                         
#include <Trade\Trade.mqh>

CTrade trade;                                     // Trade object

int handleMACD[];                                 // MACD indicator handles
int handleAtr[];                                  // ATR indicator handles
int handleVolume[];                               // Volume indicator handles
int handleMA1[];                                  // Short MA handles
int handleMA2[];                                  // Long MA handles
int handleMA3[];                                  // Structural MA handles
int handleRSI[];                                  // RSI indicator handles

int totalBars[];                                  // Total bars in tf2 timeframe for each market
bool position[];                                  // Is there an open position for each market?
bool achat[];                                     // Buy entry reason for each market
bool vente[];                                     // Sell entry reason for each market

// Declare arrays for parameters
string markets[];
double Lots[];
double RRR[];
double BE[];
double mult[];
ENUM_TIMEFRAMES tf1[];
ENUM_TIMEFRAMES tf2[];
ENUM_TIMEFRAMES tf3[];
uint macdLongLen[];
uint macdShortLen[];
uint macdSignalLen[];
bool macdLowCrossOnly[];
uint maShortPeriod[];
bool maShortEma[];
uint maLongPeriod[];
uint maStructPeriod[];
bool rsiCondition[];
uint rsiPeriod[];
uint rsiLo[];
uint rsiHi[];
uint maVolumePeriod[];
uint macdEntryTime[];
bool maConjoncturelCondition[];
bool maStructurelleCondition[];
bool patternCondition[];

// Function to calculate dynamic lot size based on capital, ATR, and fixed risk percentage
double dynamicLotCalculation(int marketIndex, double atrValue) {
    double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    double riskPercentage = 0.01;  // Fixed risk percentage (e.g., 1% of equity)
    double riskAmount = accountEquity * riskPercentage;
    double stopLossPips = mult[marketIndex] * atrValue;
    double lotSize = riskAmount / (stopLossPips * _Point * SymbolInfoDouble(markets[marketIndex], SYMBOL_TRADE_TICK_VALUE));

    // Ensure the lot size respects the broker's minimum and maximum lot size
    double minLot = SymbolInfoDouble(markets[marketIndex], SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(markets[marketIndex], SYMBOL_VOLUME_MAX);
    double stepLot = SymbolInfoDouble(markets[marketIndex], SYMBOL_VOLUME_STEP);
    
    lotSize = MathMax(minLot, MathMin(maxLot, lotSize));
    lotSize = NormalizeDouble(lotSize, (int)log10(1.0 / stepLot));

    return lotSize;
}

// Function to calculate current drawdown percentage
double CalculateDrawdownPercentage() {
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    double drawdown = accountBalance - accountEquity;
    if (accountBalance == 0) return 0.0;
    return (drawdown / accountBalance) * 100.0;
}

// Function to close all open trades
void CloseAllTrades() {
    CTrade sTrade;
    sTrade.SetAsyncMode(true);

    for(int cnt = PositionsTotal()-1; cnt >= 0 && !IsStopped(); cnt-- )
    {
        if(PositionGetTicket(cnt))
        {
            sTrade.PositionClose(PositionGetInteger(POSITION_TICKET),100);
            uint code = sTrade.ResultRetcode();
            Print(IntegerToString(code));
        }
    }
}

void InitializeAndAssign() {
    string forexSymbols[], cryptoSymbols[], otherSymbols[];
    
    if (StringLen(forex_Market) > 0) {
        StringSplit(forex_Market, "-", forexSymbols);
    }
    if (StringLen(crypto_Market) > 0) {
        StringSplit(crypto_Market, "-", cryptoSymbols);
    }
    if (StringLen(other_Market) > 0) {
        StringSplit(other_Market, "-", otherSymbols);
    }

    int numMarkets = ArraySize(forexSymbols) + ArraySize(cryptoSymbols) + ArraySize(otherSymbols);

    if (numMarkets == 0) {
        Print("No markets specified. Exiting.");
        return;
    }

    // Resize arrays based on the number of specified markets
    ArrayResize(markets, numMarkets);
    ArrayResize(Lots, numMarkets);
    ArrayResize(RRR, numMarkets);
    ArrayResize(BE, numMarkets);
    ArrayResize(mult, numMarkets);
    ArrayResize(tf1, numMarkets);
    ArrayResize(tf2, numMarkets);
    ArrayResize(tf3, numMarkets);
    ArrayResize(macdLongLen, numMarkets);
    ArrayResize(macdShortLen, numMarkets);
    ArrayResize(macdSignalLen, numMarkets);
    ArrayResize(macdLowCrossOnly, numMarkets);
    ArrayResize(maShortPeriod, numMarkets);
    ArrayResize(maShortEma, numMarkets);
    ArrayResize(maLongPeriod, numMarkets);
    ArrayResize(maStructPeriod, numMarkets);
    ArrayResize(rsiCondition, numMarkets);
    ArrayResize(rsiPeriod, numMarkets);
    ArrayResize(rsiLo, numMarkets);
    ArrayResize(rsiHi, numMarkets);
    ArrayResize(maVolumePeriod, numMarkets);
    ArrayResize(macdEntryTime, numMarkets);
    ArrayResize(maConjoncturelCondition, numMarkets);
    ArrayResize(maStructurelleCondition, numMarkets);
    ArrayResize(patternCondition, numMarkets);

    int index = 0;

    for (int i = 0; i < ArraySize(forexSymbols); i++) {
        markets[index] = forexSymbols[i];
        Lots[index] = forex_Lots;
        RRR[index] = forex_RRR;
        BE[index] = forex_BE;
        mult[index] = forex_mult;
        tf1[index] = forex_tf1;
        tf2[index] = forex_tf2;
        tf3[index] = forex_tf3;
        macdLongLen[index] = forex_macdLongLen;
        macdShortLen[index] = forex_macdShortLen;
        macdSignalLen[index] = forex_macdSignalLen;
        macdLowCrossOnly[index] = forex_macdLowCrossOnly;
        maShortPeriod[index] = forex_maShortPeriod;
        maShortEma[index] = forex_maShortEma;
        maLongPeriod[index] = forex_maLongPeriod;
        maStructPeriod[index] = forex_maStructPeriod;
        rsiCondition[index] = forex_rsiCondition;
        rsiPeriod[index] = forex_rsiPeriod;
        rsiLo[index] = forex_rsiLo;
        rsiHi[index] = forex_rsiHi;
        maVolumePeriod[index] = forex_maVolumePeriod;
        macdEntryTime[index] = forex_macdEntryTime;
        maConjoncturelCondition[index] = forex_maConjoncturelCondition;
        maStructurelleCondition[index] = forex_maStructurelleCondition;
        patternCondition[index] = forex_patternCondition;
        index++;
    }

    for (int i = 0; i < ArraySize(cryptoSymbols); i++) {
        markets[index] = cryptoSymbols[i];
        Lots[index] = crypto_Lots;
        RRR[index] = crypto_RRR;
        BE[index] = crypto_BE;
        mult[index] = crypto_mult;
        tf1[index] = crypto_tf1;
        tf2[index] = crypto_tf2;
        tf3[index] = crypto_tf3;
        macdLongLen[index] = crypto_macdLongLen;
        macdShortLen[index] = crypto_macdShortLen;
        macdSignalLen[index] = crypto_macdSignalLen;
        macdLowCrossOnly[index] = crypto_macdLowCrossOnly;
        maShortPeriod[index] = crypto_maShortPeriod;
        maShortEma[index] = crypto_maShortEma;
        maLongPeriod[index] = crypto_maLongPeriod;
        maStructPeriod[index] = crypto_maStructPeriod;
        rsiCondition[index] = crypto_rsiCondition;
        rsiPeriod[index] = crypto_rsiPeriod;
        rsiLo[index] = crypto_rsiLo;
        rsiHi[index] = crypto_rsiHi;
        maVolumePeriod[index] = crypto_maVolumePeriod;
        macdEntryTime[index] = crypto_macdEntryTime;
        maConjoncturelCondition[index] = crypto_maConjoncturelCondition;
        maStructurelleCondition[index] = crypto_maStructurelleCondition;
        patternCondition[index] = crypto_patternCondition;
        index++;
    }

    for (int i = 0; i < ArraySize(otherSymbols); i++) {
        markets[index] = otherSymbols[i];
        Lots[index] = other_Lots;
        RRR[index] = other_RRR;
        BE[index] = other_BE;
        mult[index] = other_mult;
        tf1[index] = other_tf1;
        tf2[index] = other_tf2;
        tf3[index] = other_tf3;
        macdLongLen[index] = other_macdLongLen;
        macdShortLen[index] = other_macdShortLen;
        macdSignalLen[index] = other_macdSignalLen;
        macdLowCrossOnly[index] = other_macdLowCrossOnly;
        maShortPeriod[index] = other_maShortPeriod;
        maShortEma[index] = other_maShortEma;
        maLongPeriod[index] = other_maLongPeriod;
        maStructPeriod[index] = other_maStructPeriod;
        rsiCondition[index] = other_rsiCondition;
        rsiPeriod[index] = other_rsiPeriod;
        rsiLo[index] = other_rsiLo;
        rsiHi[index] = other_rsiHi;
        maVolumePeriod[index] = other_maVolumePeriod;
        macdEntryTime[index] = other_macdEntryTime;
        maConjoncturelCondition[index] = other_maConjoncturelCondition;
        maStructurelleCondition[index] = other_maStructurelleCondition;
        patternCondition[index] = other_patternCondition;
        index++;
    }

    // Output the values for verification
    for (int i = 0; i < numMarkets; i++) {
        PrintFormat("Market: %s", markets[i]);
        PrintFormat("Lots: %f", Lots[i]);
        PrintFormat("RRR: %f", RRR[i]);
        PrintFormat("BE: %f", BE[i]);
        PrintFormat("Mult: %f", mult[i]);
        PrintFormat("TF1: %d", tf1[i]);
        PrintFormat("TF2: %d", tf2[i]);
        PrintFormat("TF3: %d", tf3[i]);
        PrintFormat("MACD Long Len: %d", macdLongLen[i]);
        PrintFormat("MACD Short Len: %d", macdShortLen[i]);
        PrintFormat("MACD Signal Len: %d", macdSignalLen[i]);
        PrintFormat("MACD Low Cross Only: %s", macdLowCrossOnly[i] ? "true" : "false");
        PrintFormat("MA Short Period: %d", maShortPeriod[i]);
        PrintFormat("MA Short EMA: %s", maShortEma[i] ? "true" : "false");
        PrintFormat("MA Long Period: %d", maLongPeriod[i]);
        PrintFormat("MA Struct Period: %d", maStructPeriod[i]);
        PrintFormat("RSI Condition: %s", rsiCondition[i] ? "true" : "false");
        PrintFormat("RSI Period: %d", rsiPeriod[i]);
        PrintFormat("RSI Lo: %d", rsiLo[i]);
        PrintFormat("RSI Hi: %d", rsiHi[i]);
        PrintFormat("MA Volume Period: %d", maVolumePeriod[i]);
        PrintFormat("MACD Entry Time: %d", macdEntryTime[i]);
        PrintFormat("MA Conjoncturel Condition: %s", maConjoncturelCondition[i] ? "true" : "false");
        PrintFormat("MA Structurelle Condition: %s", maStructurelleCondition[i] ? "true" : "false");
        PrintFormat("Pattern Condition: %s", patternCondition[i] ? "true" : "false");
    }
}

int OnInit() {
    InitializeAndAssign();
    Print("Init Success");

    int numMarkets = ArraySize(markets);

    ArrayResize(handleMACD, numMarkets);
    ArrayResize(handleAtr, numMarkets);
    ArrayResize(handleVolume, numMarkets);
    ArrayResize(handleMA1, numMarkets);
    ArrayResize(handleMA2, numMarkets);
    ArrayResize(handleMA3, numMarkets);
    ArrayResize(handleRSI, numMarkets);
    ArrayResize(totalBars, numMarkets);
    ArrayResize(position, numMarkets);
    ArrayResize(achat, numMarkets);
    ArrayResize(vente, numMarkets);

    for (int i = 0; i < numMarkets; i++) {
        handleMACD[i] = iCustom(markets[i], tf2[i], "TrueMACD.ex5", macdLongLen[i], macdShortLen[i], macdSignalLen[i]);
        handleAtr[i] = iATR(markets[i], tf2[i], 20);
        if (maShortEma[i]) handleMA1[i] = iMA(markets[i], tf1[i], maShortPeriod[i], 0, MODE_EMA, PRICE_CLOSE);
        else handleMA1[i] = iMA(markets[i], tf1[i], maShortPeriod[i], 0, MODE_SMA, PRICE_CLOSE);
        handleMA2[i] = iMA(markets[i], tf1[i], maLongPeriod[i], 0, MODE_SMA, PRICE_CLOSE);
        handleMA3[i] = iMA(markets[i], tf1[i], maStructPeriod[i], 0, MODE_SMA, PRICE_CLOSE);
        handleRSI[i] = iRSI(markets[i], tf1[i], rsiPeriod[i], PRICE_CLOSE);

        totalBars[i] = iBars(markets[i], tf2[i]);
        position[i] = false;
        achat[i] = false;
        vente[i] = false;
    }

    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    // Clean up
}

void CopyBuffers(int marketIndex, uint barsToCopy, double &macdSignal[], double &macdHisto[], double &maShort[], double &maLong[], double &maStruct[], double &rsi[], double &atr[]) {
    CopyBuffer(handleMACD[marketIndex], 1, 1, barsToCopy, macdSignal);
    CopyBuffer(handleMACD[marketIndex], 2, 1, barsToCopy, macdHisto);
    CopyBuffer(handleMA1[marketIndex], 0, 1, 1, maShort);
    CopyBuffer(handleMA2[marketIndex], 0, 1, 1, maLong);
    CopyBuffer(handleMA3[marketIndex], 0, 1, 1, maStruct);
    CopyBuffer(handleRSI[marketIndex], 0, 1, 1, rsi);
    CopyBuffer(handleAtr[marketIndex], 0, 1, 1, atr);
}

bool CheckMACDCondition(int marketIndex, double &macdHisto[], double &macdSignal[]) {
    for (uint i = 0; i < macdEntryTime[marketIndex]; i++) {
        bool candlesAreGreen = true;
        bool histoTurnGreen = (macdHisto[3 + i] > 0) && (macdHisto[2 + i] < 0) && (macdHisto[1 + i] < 0) && (macdHisto[0 + i] < 0);
        bool negativeLine = (!macdLowCrossOnly[marketIndex]) || (macdSignal[0 + i] < 0 && macdSignal[1 + i] < 0 && macdSignal[2 + i] < 0);

        if (histoTurnGreen && negativeLine) {
            for (uint j = i + 1; j < macdEntryTime[marketIndex]; j++) {
                candlesAreGreen = candlesAreGreen && (macdHisto[3 + j] > macdHisto[3 + j - 1]);
            }
            if (candlesAreGreen) {
                return true;
            }
        }
    }
    return false;
}

bool CheckPatternCondition(int marketIndex) {
    bool patternCondVerifier = false;
    uint lag = 1;

    while (iClose(markets[marketIndex], tf3[marketIndex], lag) > iOpen(markets[marketIndex], tf3[marketIndex], lag)) {
        bool redCandle = iClose(markets[marketIndex], tf3[marketIndex], lag + 1) < iOpen(markets[marketIndex], tf3[marketIndex], lag + 1);
        patternCondVerifier = redCandle && (iClose(markets[marketIndex], tf3[marketIndex], lag) > iOpen(markets[marketIndex], tf3[marketIndex], lag + 1));
        patternCondVerifier = patternCondVerifier || (((iHigh(markets[marketIndex], tf3[marketIndex], lag) - iLow(markets[marketIndex], tf3[marketIndex], lag)) / (iHigh(markets[marketIndex], tf3[marketIndex], lag) - iOpen(markets[marketIndex], tf3[marketIndex], lag))) > 3);

        if (patternCondVerifier) {
            break;
        }

        lag++;
    }

    return patternCondVerifier || !patternCondition[marketIndex];
}

void tpsl_calculation(int marketIndex, double entry, double &sl, double &tp, double &atr[]) {
    sl = entry - mult[marketIndex] * atr[0] - (entry - iLow(markets[marketIndex], tf2[marketIndex], 1));
    tp = entry + mult[marketIndex] * RRR[marketIndex] * atr[0];
}

bool CheckEntryConditions(int marketIndex, double &macdHisto[], double &macdSignal[], double &maShort[], double &maLong[], double &maStruct[], double &rsi[]) {
    bool rsiCond = (!rsiCondition[marketIndex]) || ((rsi[0] >= rsiLo[marketIndex]) && (rsi[0] <= rsiHi[marketIndex]));
    bool conjoncturelCondition = (!maConjoncturelCondition[marketIndex]) || (maShort[0] > maLong[0]);
    bool structurelCondition = (!maStructurelleCondition[marketIndex]) || (maLong[0] > maStruct[0]);
    bool trendCondition = rsiCond && conjoncturelCondition && structurelCondition;
    bool macdCond = CheckMACDCondition(marketIndex, macdHisto, macdSignal);
    bool patternCondVerifier = CheckPatternCondition(marketIndex);

    return patternCondVerifier && macdCond && trendCondition;
}

void CheckExitConditions(int marketIndex) {
    if (!PositionSelect(markets[marketIndex])) {
        position[marketIndex] = false;
    }
}

void OnTick() {
    int numMarkets = ArraySize(markets);

    // Check for Force Close
    if (ForceClose > 0 && CalculateDrawdownPercentage() > ForceClose) {
        CloseAllTrades();
        return;
    }

    for (int i = 0; i < numMarkets; i++) {
        int bars = iBars(markets[i], tf3[i]);
        if (bars <= totalBars[i])
            continue;

        totalBars[i] = bars;
        uint barsToCopy = 4 + macdEntryTime[i] - 1;
        double macdSignal[], macdHisto[], maShort[1], maLong[1], maStruct[1], rsi[1], atr[1];

        CopyBuffers(i, barsToCopy, macdSignal, macdHisto, maShort, maLong, maStruct, rsi, atr);

        bool conditionAchat = CheckEntryConditions(i, macdHisto, macdSignal, maShort, maLong, maStruct, rsi);

        if (conditionAchat && !position[i]) {
            position[i] = true;
            double entry = NormalizeDouble(SymbolInfoDouble(markets[i], SYMBOL_ASK), _Digits);
            double tp, sl;
            tpsl_calculation(i, entry, sl, tp, atr);
            double dynamicLot = dynamicLotCalculation(i, atr[0]);
            trade.Buy(dynamicLot, markets[i], entry, sl, tp, "Achat");
        }

        CheckExitConditions(i);

        // Break Even Logic
        if (position[i] && PositionSelect(markets[i])) {
            double currentPrice = SymbolInfoDouble(markets[i], SYMBOL_BID);
            double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double stopLoss = PositionGetDouble(POSITION_SL);
            double atrValue = atr[0];
            double bePrice = entryPrice + BE[i] * mult[i] * atrValue;

            if (currentPrice >= bePrice) {
                double newSL = NormalizeDouble(entryPrice + (atrValue * 0.5 * _Point), _Digits);  // Small buffer
                if (newSL > stopLoss) {
                    trade.PositionModify(PositionGetInteger(POSITION_IDENTIFIER), newSL, PositionGetDouble(POSITION_TP));
                }
            }
        }
    }
}
