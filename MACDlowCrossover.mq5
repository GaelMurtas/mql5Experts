#include <trade/trade.mqh>
#include "C:\Program Files\MetaTrader 5\MQL5\Indicators\gaelM_Indicators\TrueMACD.mqh"

input group               "          MACDLowCrossover          ";
                        input group               "         Version Upgraded           ";
                        input group               "      Author : @GaelMurtas & @FlorianPascual        ";
                        input group               "           Company : Quenya SAS           ";
                        input group                                       " ";
                        
                        input group                                       "";
                        input group                                       " ------ SET n1";
                        input group                                       "";
                        input group                                       " - MARKETS";
                        input string set1_Market = "GBPUSD";             // Forex market symbol
                        
                        input group                                       " - RISK";
                        input double set1_Risk = 1;                      // risk for eatch trade in %
                        input double set1_RRR = 1.5;                     // Risk Reward Ratio
                        input double set1_BE = 0.8;                      // Break Even Point
                        input double set1_mult = 1.0;                    // Risk size multiplier (in ATR)
                        
                        input group                                       " - TIMEFRAME";
                        input ENUM_TIMEFRAMES set1_tf1 = PERIOD_D1;      // Timeframe 1 (Daily)
                        input ENUM_TIMEFRAMES set1_tf2 = PERIOD_H4;      // Timeframe 2 (4 Hours)
                        input ENUM_TIMEFRAMES set1_tf3 = PERIOD_H1;      // Timeframe 3 (1 Hour)
                        
                        input group                                       " - MACD";
                        input uint set1_macdLongLen = 26;                // MACD long period length
                        input uint set1_macdShortLen = 12;               // MACD short period length
                        input uint set1_macdSignalLen = 9;               // MACD signal line length
                        input bool set1_macdLowCrossOnly = true;         // Use low crossover only for MACD
                        input MA::MAtype set1_macdMaType = MA::EMA;      //type of mooving average for macd Calcul
                        input uint set1_macdEntryTime = 3;               // MACD entry window (candles)
                        
                        input group                                     " - MOVING AVERAGES";
                        input bool set1_enableMA = true;                        //enable MA indicators               
                        input uint set1_maShortPeriod = 20;              // Short MA period
                        input bool set1_maShortEma = false;              // Use EMA for short MA
                        input bool set1_maSimpleCondition = false;       // Use only shortest and longest MA
                        input uint set1_maLongPeriod = 50;               // Long MA period
                        input bool set1_maConjoncturelCondition = true;  // Use conjunctural trend condition
                        input uint set1_maStructPeriod = 200;            // Structural MA period
                        input bool set1_maStructurelleCondition = true;  // Use structural trend condition
                        
                        input group                                       " - RSI";
                        input bool set1_enableRsi = true;                       // enable RSI indicator
                        input bool set1_rsiCondition = true;             // Use RSI condition
                        input uint set1_rsiPeriod = 12;                  // RSI period length
                        input uint set1_rsiLo = 55;                      // Lower RSI threshold
                        input uint set1_rsiHi = 85;                      // Upper RSI threshold
                        input bool set1_rsiMaCond = false;               // rsi should be above his MA
                        input uint set1_rsiMa = 10;                      // size of mooving adverage of RSI
                        //1 will disable
                        
                        input group                                       " - PARTERN";
                        input bool set1_enablePattern = true;            //enable use of pattern indicator
                        input bool set1_patternCondition = true;         // Use pattern condition
                        input uint set1_patternEntryTime = 3;            // MACD entry window (candles)
                        //input uint set1_maVolumePeriod = 10;           // Volume MA period
                        
                        
                        input group                                       "";
                        input group                                       " ------ SET n2";
                        input group                                       "";
                        input group                                       " - MARKETS";
                        input string set2_Market = "";             // Forex market symbol
                        
                        input group                                       " - RISK";
                        input double set2_Risk = 1;                    // risk for eatch trade in %
                        input double set2_RRR = 1.5;                     // Risk Reward Ratio
                        input double set2_BE = 0.8;                      // Break Even Point
                        input double set2_mult = 1.0;                    // Risk size multiplier (in ATR)
                        
                        input group                                       " - TIMEFRAME";
                        input ENUM_TIMEFRAMES set2_tf1 = PERIOD_D1;      // Timeframe 1 (Daily)
                        input ENUM_TIMEFRAMES set2_tf2 = PERIOD_H4;      // Timeframe 2 (4 Hours)
                        input ENUM_TIMEFRAMES set2_tf3 = PERIOD_H1;      // Timeframe 3 (1 Hour)
                        
                        input group                                       " - MACD";
                        input uint set2_macdLongLen = 26;                // MACD long period length
                        input uint set2_macdShortLen = 12;               // MACD short period length
                        input uint set2_macdSignalLen = 9;               // MACD signal line length
                        input bool set2_macdLowCrossOnly = true;         // Use low crossover only for MACD
                        input MA::MAtype set2_macdMaType = MA::EMA;      //type of mooving average for macd Calcul
                        input uint set2_macdEntryTime = 3;               // MACD entry window (candles)
                        
                        input group                                     " - MOVING AVERAGES";
                        input bool set2_enableMA = true;                        //enable MA indicators               
                        input uint set2_maShortPeriod = 20;              // Short MA period
                        input bool set2_maShortEma = false;              // Use EMA for short MA
                        input bool set2_maSimpleCondition = false;       // Use only shortest and longest MA
                        input uint set2_maLongPeriod = 50;               // Long MA period
                        input bool set2_maConjoncturelCondition = true;  // Use conjunctural trend condition
                        input uint set2_maStructPeriod = 200;            // Structural MA period
                        input bool set2_maStructurelleCondition = true;  // Use structural trend condition
                        
                        input group                                       " - RSI";
                        input bool set2_enableRsi = true;                       // enable RSI indicator
                        input bool set2_rsiCondition = true;             // Use RSI condition
                        input uint set2_rsiPeriod = 12;                  // RSI period length
                        input uint set2_rsiLo = 55;                      // Lower RSI threshold
                        input uint set2_rsiHi = 85;                      // Upper RSI threshold
                        input bool set2_rsiMaCond = false;               // rsi should be above his MA
                        input uint set2_rsiMa = 10;                       // size of mooving adverage of RSI
                        //1 will disable
                        
                        input group                                       " - PARTERN";
                        input bool set2_enablePattern = true;                   //enable use of pattern indicator
                        input bool set2_patternCondition = true;         // Use pattern condition
                        input uint set2_patternEntryTime = 3;            // MACD entry window (candles)
                        //input uint set1_maVolumePeriod = 10;             // Volume MA period
                        
                        
                        input group                                       "";
                        input group                                       " ------ SET n3";
                        input group                                       "";
                        input group                                       " - MARKETS";
                        input string set3_Market = "";             // Forex market symbol
                        
                        input group                                       " - RISK";
                        input double set3_Risk = 1;                    // risk for eatch trade in %
                        input double set3_RRR = 1.5;                     // Risk Reward Ratio
                        input double set3_BE = 0.8;                      // Break Even Point
                        input double set3_mult = 1.0;                    // Risk size multiplier (in ATR)
                        
                        input group                                       " - TIMEFRAME";
                        input ENUM_TIMEFRAMES set3_tf1 = PERIOD_D1;      // Timeframe 1 (Daily)
                        input ENUM_TIMEFRAMES set3_tf2 = PERIOD_H4;      // Timeframe 2 (4 Hours)
                        input ENUM_TIMEFRAMES set3_tf3 = PERIOD_H1;      // Timeframe 3 (1 Hour)
                        
                        input group                                       " - MACD";
                        input uint set3_macdLongLen = 26;                // MACD long period length
                        input uint set3_macdShortLen = 12;               // MACD short period length
                        input uint set3_macdSignalLen = 9;               // MACD signal line length
                        input bool set3_macdLowCrossOnly = true;         // Use low crossover only for MACD
                        input MA::MAtype set3_macdMaType = MA::EMA;      //type of mooving average for macd Calcul
                        input uint set3_macdEntryTime = 3;               // MACD entry window (candles)
                        
                        input group                                     " - MOVING AVERAGES";
                        input bool set3_enableMA = true;                        //enable MA indicators               
                        input uint set3_maShortPeriod = 20;              // Short MA period
                        input bool set3_maShortEma = false;              // Use EMA for short MA
                        input bool set3_maSimpleCondition = false;       // Use only shortest and longest MA
                        input uint set3_maLongPeriod = 50;               // Long MA period
                        input bool set3_maConjoncturelCondition = true;  // Use conjunctural trend condition
                        input uint set3_maStructPeriod = 200;            // Structural MA period
                        input bool set3_maStructurelleCondition = true;  // Use structural trend condition
                        
                        input group                                       " - RSI";
                        input bool set3_enableRsi = true;                       // enable RSI indicator
                        input bool set3_rsiCondition = true;             // Use RSI condition
                        input uint set3_rsiPeriod = 12;                  // RSI period length
                        input uint set3_rsiLo = 55;                      // Lower RSI threshold
                        input uint set3_rsiHi = 85;                      // Upper RSI threshold
                        input bool set3_rsiMaCond = false;               // rsi should be above his MA
                        input uint set3_rsiMa = 10;                       // size of mooving adverage of RSI
                        //1 will disable
                        
                        input group                                       " - PARTERN";
                        input bool set3_enablePattern = true;                   //enable use of pattern indicator
                        input bool set3_patternCondition = true;         // Use pattern condition
                        input uint set3_patternEntryTime = 3;            // MACD entry window (candles)
                        //input uint set1_maVolumePeriod = 10;             // Volume MA period

//Global Variable
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
double risk[];
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
MA::MAtype macdMaType[];
uint macdEntryTime[];

bool enableMA[];
uint maShortPeriod[];
bool maShortEma[];
bool maSimpleCondition[];
uint maLongPeriod[];
bool maConjoncturelCondition[];
uint maStructPeriod[];
bool maStructurelleCondition[];

bool enableRSI[];
bool rsiCondition[];
uint rsiPeriod[];
uint rsiLo[];
uint rsiHi[];
uint rsiMaCond[];
uint rsiMa[];

bool enablePattern[];
bool patternCondition[];
uint patternEntryTime[];
//uint maVolumePeriod[];

void InitializeAndAssign() {
    string set1Symbols[], set2Symbols[], set3Symbols[];
    
    if (StringLen(set1_Market) > 0) {
        StringSplit(set1_Market, '-', set1Symbols);
    }
    if (StringLen(set2_Market) > 0) {
        StringSplit(set2_Market, '-', set2Symbols);
    }
    if (StringLen(set3_Market) > 0) {
        StringSplit(set3_Market, '-', set3Symbols);
    }

    int numMarkets = ArraySize(set1Symbols) + ArraySize(set2Symbols) + ArraySize(set3Symbols);

    if (numMarkets == 0) {
        Print("No markets specified. Exiting.");
        return;
    }

    // Resize arrays based on the number of specified markets
    ArrayResize(markets, numMarkets);
    ArrayResize(risk, numMarkets);
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
    ArrayResize(macdMaType, numMarkets);
    ArrayResize(macdEntryTime, numMarkets);
    
    ArrayResize(enableMA, numMarkets);
    ArrayResize(macdEntryTime, numMarkets);
    ArrayResize(maShortPeriod, numMarkets);
    ArrayResize(maShortEma, numMarkets);
    ArrayResize(maSimpleCondition, numMarkets);
    ArrayResize(maLongPeriod, numMarkets);
    ArrayResize(maStructPeriod, numMarkets);
    ArrayResize(maConjoncturelCondition, numMarkets);
    ArrayResize(maStructurelleCondition, numMarkets);
    
    ArrayResize(enableRSI, numMarkets);
    ArrayResize(rsiCondition, numMarkets);
    ArrayResize(rsiPeriod, numMarkets);
    ArrayResize(rsiLo, numMarkets);
    ArrayResize(rsiHi, numMarkets);
    ArrayResize(rsiMaCond, numMarkets);
    ArrayResize(rsiMa, numMarkets);
    
    ArrayResize(enablePattern, numMarkets);
    //ArrayResize(maVolumePeriod, numMarkets);
    ArrayResize(patternEntryTime, numMarkets);
    ArrayResize(patternCondition, numMarkets);

    int index = 0;

    for (int i = 0; i < ArraySize(set1Symbols); i++) {
        markets[index] = set1Symbols[i];
        risk[index] = set1_Risk;
        RRR[index] = set1_RRR;
        BE[index] = set1_BE;
        mult[index] = set1_mult;
        tf1[index] = set1_tf1;
        tf2[index] = set1_tf2;
        tf3[index] = set1_tf3;
        
        macdLongLen[index] = set1_macdLongLen;
        macdShortLen[index] = set1_macdShortLen;
        macdSignalLen[index] = set1_macdSignalLen;
        macdLowCrossOnly[index] = set1_macdLowCrossOnly;
        macdMaType[index] = set1_macdMaType;
        
        enableMA[index] = set1_enableMA;
        maShortPeriod[index] = set1_maShortPeriod;
        maShortEma[index] = set1_maShortEma;
        maSimpleCondition[index] = set1_maSimpleCondition;
        maLongPeriod[index] = set1_maLongPeriod;
        maStructPeriod[index] = set1_maStructPeriod;
        
        maConjoncturelCondition[index] = set1_maConjoncturelCondition;
        maStructurelleCondition[index] = set1_maStructurelleCondition;
        
        enableRSI[index] = set1_enableRsi;
        rsiCondition[index] = set1_rsiCondition;
        rsiPeriod[index] = set1_rsiPeriod;
        rsiLo[index] = set1_rsiLo;
        rsiHi[index] = set1_rsiHi;
        rsiMaCond[index] = set1_rsiMaCond;
        rsiMa[index] = set1_rsiMa;
        
        enablePattern[index] = set1_enablePattern;
        //maVolumePeriod[index] = set1_maVolumePeriod;
        macdEntryTime[index] = set1_macdEntryTime;
        patternCondition[index] = set1_patternCondition;
        patternEntryTime[index] = set1_patternEntryTime;
        index ++;
    }
    
    for (int i = 0; i < ArraySize(set2Symbols); i++) {
        markets[index] = set2Symbols[i];
        risk[index] = set2_Risk;
        RRR[index] = set2_RRR;
        BE[index] = set2_BE;
        mult[index] = set2_mult;
        tf1[index] = set2_tf1;
        tf2[index] = set2_tf2;
        tf3[index] = set2_tf3;
        
        macdLongLen[index] = set2_macdLongLen;
        macdShortLen[index] = set2_macdShortLen;
        macdSignalLen[index] = set2_macdSignalLen;
        macdLowCrossOnly[index] = set2_macdLowCrossOnly;
        macdMaType[index] = set2_macdMaType;
        
        enableMA[index] = set2_enableMA;
        maShortPeriod[index] = set2_maShortPeriod;
        maShortEma[index] = set2_maShortEma;
        maSimpleCondition[index] = set2_maSimpleCondition;
        maLongPeriod[index] = set2_maLongPeriod;
        maStructPeriod[index] = set2_maStructPeriod;
        
        maConjoncturelCondition[index] = set2_maConjoncturelCondition;
        maStructurelleCondition[index] = set2_maStructurelleCondition;
        
        enableRSI[index] = set2_enableRsi;
        rsiCondition[index] = set2_rsiCondition;
        rsiPeriod[index] = set2_rsiPeriod;
        rsiLo[index] = set2_rsiLo;
        rsiHi[index] = set2_rsiHi;
        rsiMaCond[index] = set2_rsiMaCond;
        rsiMa[index] = set2_rsiMa;
        
        enablePattern[index] = set2_enablePattern;
        //maVolumePeriod[index] = set1_maVolumePeriod;
        macdEntryTime[index] = set2_macdEntryTime;
        patternCondition[index] = set2_patternCondition;
        patternEntryTime[index] = set2_patternEntryTime;
        index ++;
    }
    
    for (int i = 0; i < ArraySize(set3Symbols); i++) {
        markets[index] = set3Symbols[i];
        risk[index] = set3_Risk;
        RRR[index] = set3_RRR;
        BE[index] = set3_BE;
        mult[index] = set3_mult;
        tf1[index] = set3_tf1;
        tf2[index] = set3_tf2;
        tf3[index] = set3_tf3;
        
        macdLongLen[index] = set3_macdLongLen;
        macdShortLen[index] = set3_macdShortLen;
        macdSignalLen[index] = set3_macdSignalLen;
        macdLowCrossOnly[index] = set3_macdLowCrossOnly;
        macdMaType[index] = set3_macdMaType;
        
        enableMA[index] = set3_enableMA;
        maShortPeriod[index] = set3_maShortPeriod;
        maShortEma[index] = set3_maShortEma;
        maSimpleCondition[index] = set3_maSimpleCondition;
        maLongPeriod[index] = set3_maLongPeriod;
        maStructPeriod[index] = set3_maStructPeriod;
        
        maConjoncturelCondition[index] = set3_maConjoncturelCondition;
        maStructurelleCondition[index] = set3_maStructurelleCondition;
        
        enableRSI[index] = set3_enableRsi;
        rsiCondition[index] = set3_rsiCondition;
        rsiPeriod[index] = set3_rsiPeriod;
        rsiLo[index] = set3_rsiLo;
        rsiHi[index] = set3_rsiHi;
        rsiMaCond[index] = set3_rsiMaCond;
        rsiMa[index] = set3_rsiMa;
        
        enablePattern[index] = set3_enablePattern;
        //maVolumePeriod[index] = set1_maVolumePeriod;
        macdEntryTime[index] = set3_macdEntryTime;
        patternCondition[index] = set3_patternCondition;
        patternEntryTime[index] = set3_patternEntryTime;
        index ++;
    }
    
 // Output the values for verification
 /*   for (int i = 0; i < numMarkets; i++) {
        PrintFormat("Market: %s", markets[i]);
        PrintFormat("Risk: %f", risk[i]);
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
        PrintFormat("MACD MA type: %d", macdMaType[i]);
        PrintFormat("MACD Entry Time: %d", macdEntryTime[i]);
        PrintFormat("MA Short Period: %d", maShortPeriod[i]);
        PrintFormat("MA Short EMA: %s", maShortEma[i] ? "true" : "false");
        PrintFormat("MA Long Period: %d", maLongPeriod[i]);
        PrintFormat("MA Struct Period: %d", maStructPeriod[i]);
        PrintFormat("MA Conjoncturel Condition: %s", maConjoncturelCondition[i] ? "true" : "false");
        PrintFormat("MA Structurelle Condition: %s", maStructurelleCondition[i] ? "true" : "false");
        PrintFormat("RSI Condition: %s", rsiCondition[i] ? "true" : "false");
        PrintFormat("RSI Period: %d", rsiPeriod[i]);
        PrintFormat("RSI Lo: %d", rsiLo[i]);
        PrintFormat("RSI Hi: %d", rsiHi[i]);
        PrintFormat("RSI MA length: %d", rsiMa[i]);
        PrintFormat("Pattern Condition: %s", patternCondition[i] ? "true" : "false");
        //PrintFormat("MA Volume Period: %d", maVolumePeriod[i]);
        PrintFormat("Pattern Entry Time: %d", patternEntryTime[i]);
    }*/
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
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
        handleMACD[i] = iCustom(markets[i], tf2[i], "gaelM_Indicators/TrueMACD.ex5", macdLongLen[i], macdShortLen[i], macdSignalLen[i], macdMaType[i]);
        handleAtr[i] = iATR(markets[i], tf2[i], 20);
        if (maShortEma[i]) handleMA1[i] = iMA(markets[i], tf1[i], maShortPeriod[i], 0, MODE_EMA, PRICE_CLOSE);
        else handleMA1[i] = iMA(markets[i], tf1[i], maShortPeriod[i], 0, MODE_SMA, PRICE_CLOSE);
        handleMA2[i] = iMA(markets[i], tf1[i], maLongPeriod[i], 0, MODE_SMA, PRICE_CLOSE);
        handleMA3[i] = iMA(markets[i], tf1[i], maStructPeriod[i], 0, MODE_SMA, PRICE_CLOSE);
        handleRSI[i] = iRSI(markets[i], tf1[i], rsiPeriod[i]+rsiMa[i], PRICE_CLOSE);

        totalBars[i] = iBars(markets[i], tf3[i]);
        position[i] = false;
        achat[i] = false;
        vente[i] = false;
    }

    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    // Clean up
  }
  
  void CopyBuffers(int marketIndex, uint barsToCopy, double &macdSignal[], double &macdHisto[], double &maShort[], double &maLong[], double &maStruct[], double &rsi[], double &atr[]) {
    CopyBuffer(handleMACD[marketIndex], 1, 1, barsToCopy, macdSignal);
    CopyBuffer(handleMACD[marketIndex], 2, 1, barsToCopy, macdHisto);
    CopyBuffer(handleMA1[marketIndex], 0, 1, 1, maShort);
    CopyBuffer(handleMA2[marketIndex], 0, 1, 1, maLong);
    CopyBuffer(handleMA3[marketIndex], 0, 1, 1, maStruct);
    CopyBuffer(handleRSI[marketIndex], 0, 1, max(1,rsiMa[marketIndex]), rsi);
    CopyBuffer(handleAtr[marketIndex], 0, 1, 1, atr);
}

//condition principale
//fennêtre de validité du macd
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

bool CheckTrendCondition(int marketIndex, double &maShort[], double &maLong[], double &maStruct[], double &rsi[]) {
    //condition sur le RSI
    MA maRsi(MA::SMA, rsiMa[marketIndex], 1, rsi);
    bool rsiCond = (!rsiCondition[marketIndex]) || ((rsi[0] >= rsiLo[marketIndex]) && (rsi[0] <= rsiHi[marketIndex]) && ((rsi[0] >= maRsi.get(0)) || (!rsiMaCond[marketIndex])));
    //condition sur les moyenne mobiles
    bool simpleCondition = maSimpleCondition[marketIndex] && (maShort[0] > maStruct[0]);
    bool conjoncturelCondition = (!maConjoncturelCondition[marketIndex]) || (maShort[0] > maLong[0]);
    bool structurelCondition = (!maStructurelleCondition[marketIndex]) || (maLong[0] > maStruct[0]);
    return (!enableRSI[marketIndex] || rsiCond) && (!enableMA[marketIndex] || (simpleCondition || (conjoncturelCondition && structurelCondition)));
}

bool CheckPatternCondition(int marketIndex) {
   if(!enablePattern[marketIndex]) return true;
    bool patternCondVerifier = false;
    uint lag = 1;
      //on regarde en arrière tant que les bougie sont vertes pour trouver le pattern
    while (iClose(markets[marketIndex], tf3[marketIndex], lag) > iOpen(markets[marketIndex], tf3[marketIndex], lag)) {
        bool redCandle = iClose(markets[marketIndex], tf3[marketIndex], lag + 1) < iOpen(markets[marketIndex], tf3[marketIndex], lag + 1);
        // close above pattern
        patternCondVerifier = redCandle && (iClose(markets[marketIndex], tf3[marketIndex], lag) > iOpen(markets[marketIndex], tf3[marketIndex], lag + 1));
      //hammer pattern pour bougie verte
        patternCondVerifier = patternCondVerifier || (((iHigh(markets[marketIndex], tf3[marketIndex], lag) - iLow(markets[marketIndex], tf3[marketIndex], lag)) / (iHigh(markets[marketIndex], tf3[marketIndex], lag) - iOpen(markets[marketIndex], tf3[marketIndex], lag))) > 3);
        if (patternCondVerifier) {
            break;
        }
        if(lag >= patternEntryTime[marketIndex]) break;
        lag++;
    }
    return patternCondVerifier || !patternCondition[marketIndex];
}

bool CheckEntryConditions(int marketIndex, double &macdHisto[], double &macdSignal[], double &maShort[], double &maLong[], double &maStruct[], double &rsi[]) {
    bool trendCondition = CheckTrendCondition(marketIndex, maShort, maLong, maStruct, rsi);
    bool macdCond = CheckMACDCondition(marketIndex, macdHisto, macdSignal);
    bool patternCondVerifier = CheckPatternCondition(marketIndex);
    return patternCondVerifier && macdCond && trendCondition;
}

void tpsl_calculation(int marketIndex, double entry, double &sl, double &tp, double &atr[]) {
    sl = entry - mult[marketIndex] * atr[0] - (entry - iLow(markets[marketIndex], tf2[marketIndex], 1));
    tp = entry + mult[marketIndex] * RRR[marketIndex] * atr[0];
}

//

// Function to calculate dynamic lot size based on capital, ATR, and fixed risk percentage
double dynamicLotCalculation(int marketIndex, double atrValue) {
    double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    double riskPercentage = risk[marketIndex]/100;  // Fixed risk percentage (e.g., 1% of equity)
    //uint facteurConversion = 100;//on transforme les double en int pour les tronqué mais après les avoir multiplier par un facteur
    double riskAmount = accountEquity * riskPercentage;Print(DoubleToString(riskAmount,8));
    double stopLossSize = mult[marketIndex] * atrValue;Print(DoubleToString(stopLossSize,8));
    double lotSize = SymbolInfoDouble(markets[marketIndex], SYMBOL_POINT) * riskAmount / stopLossSize;Print(DoubleToString(lotSize,8));

    // Ensure the lot size respects the broker's minimum and maximum lot size
    double minLot = SymbolInfoDouble(markets[marketIndex], SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(markets[marketIndex], SYMBOL_VOLUME_MAX);
    double stepLot = SymbolInfoDouble(markets[marketIndex], SYMBOL_VOLUME_STEP);
    lotSize = NormalizeDouble(lotSize, (int)log10(1/stepLot));Print(DoubleToString(lotSize,8));
    lotSize = MathMax(minLot, MathMin(maxLot, lotSize));Print(DoubleToString(lotSize,8));

    return lotSize;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
       for (int i = 0; i < ArraySize(markets); i++) {
        int bars = iBars(markets[i], tf3[i]);
        if (bars <= totalBars[i]) continue;
        totalBars[i] = bars;
        uint barsToCopy = 4 + macdEntryTime[i] - 1;
        double macdSignal[], macdHisto[], maShort[1], maLong[1], maStruct[1], rsi[], atr[1];
        ArrayResize(rsi,max(1,rsiMa[i]));

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
         if(! PositionSelect(markets[i])){
            position[i] = false;
         }
         
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