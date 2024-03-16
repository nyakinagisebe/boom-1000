//+------------------------------------------------------------------+
//|                                                     Boom1000Bot.mq5|
//|                        Copyright 2024, Your Company Name         |
//|                                       https://www.yourwebsite.com|
//+------------------------------------------------------------------+
#property strict

// Include necessary files
#include <Trade.mqh>
#include <SymbolsInfo.mqh>

// Input parameters
input double lotSize = 0.1; // Lot size for trading
input double stopLoss = 0.3; // Stop loss distance in points (0.3 in Boom 1000 market)
input double takeProfit = 0.5; // Take profit distance in points (0.5 in Boom 1000 market)

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialize the expert
    Print("Boom 1000 Bot initialized successfully");
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Deinitialize the expert
    Print("Boom 1000 Bot deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Check if it's time to trade (every three candlesticks)
    static int counter = 0;
    counter++;
    
    if (counter == 3)
    {
        // Open a sell trade
        request.sl = NormalizeDouble(request.price + sl * Point, _Digits);
        request.tp = NormalizeDouble(request.price - tp * Point, _Digits);

        
        MqlTradeRequest request = {0};
        MqlTradeResult result = {0};
        
        request.action = TRADE_ACTION_DEAL;
        request.type = ORDER_TYPE_SELL;
        request.symbol = Symbol();
        request.volume = lotSize;
        request.price = Bid;
        request.sl = sl;
        request.tp = tp;
        
        OrderSend(request, result);
        
        // Check for order placement success
        if (result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Sell order placed successfully. Ticket: ", result.deal);
        }
        else
        {
            Print("Failed to place sell order. Error code: ", result.retcode);
        }
        
        // Reset the counter
        counter = 0;
    }
}

//+------------------------------------------------------------------+

