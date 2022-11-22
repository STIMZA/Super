//+------------------------------------------------------------------+
//| The function sets chart background color.                        |
//+------------------------------------------------------------------+
bool ChartBackColorSet(const color clr,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_COLOR_BACKGROUND,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function sets the color of axes, scale and OHLC line.        |
//+------------------------------------------------------------------+
bool ChartForeColorSet(const color clr,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_COLOR_FOREGROUND,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function sets color of up bar, its shadow and                |
//| border of a bullish candlestick's body.                          |
//+------------------------------------------------------------------+
bool ChartUpColorSet(const color clr,const long chart_ID=0){

   ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_COLOR_CHART_UP,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function sets color of down bar, its shadow and              |
//| border of a bearish candlestick's body.                          |
//+------------------------------------------------------------------+
bool ChartDownColorSet(const color clr,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_COLOR_CHART_DOWN,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function sets the color of the chart line and Doji           |
//| candlesticks.                                                    |
//+------------------------------------------------------------------+
bool ChartLineColorSet(const color clr,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_COLOR_CHART_LINE,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function sets color of bullish candlestick's body.           |
//+------------------------------------------------------------------+
bool ChartBullColorSet(const color clr,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_COLOR_CANDLE_BULL,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function sets color of bearish candlestick's body.           |
//+------------------------------------------------------------------+
bool ChartBearColorSet(const color clr,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_COLOR_CANDLE_BEAR,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function sets the color of Bid line.                         |
//+------------------------------------------------------------------+
bool ChartBidColorSet(const color clr,const long chart_ID=0){

   ResetLastError();

   if(!ChartSetInteger(chart_ID,CHART_COLOR_BID,clr)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
   }

   return(true);
}

//+------------------------------------------------------------------+
//| The function sets the color of Ask line.                         |
//+------------------------------------------------------------------+
bool ChartAskColorSet(const color clr,const long chart_ID=0){

   ResetLastError();

   if(!ChartSetInteger(chart_ID,CHART_COLOR_ASK,clr)){
        //--- display the error message in Experts journal
        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
   }

   return(true);
}

//+------------------------------------------------------------------+
//| The function enables/disables the mode of the autoscroll         |
//| of the chart to the right in case of new ticks' arrival.         |
//+------------------------------------------------------------------+
bool ChartAutoscrollSet(const bool value,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_AUTOSCROLL,0,value)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+--------------------------------------------------------------------------+
//| The function enables/disables the mode of displaying a price chart with  |
//| a shift from the right border.                                           |
//+--------------------------------------------------------------------------+
bool ChartShiftSet(const bool value,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_SHIFT,0,value)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

bool ChartModeSet(const long value,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_MODE,value)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+--------------------------------------------------------------------+
//| The function enables/disables the mode of displaying Bid line on a |
//| chart.                                                             |
//+--------------------------------------------------------------------+
bool ChartShowBidLineSet(const bool value,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_SHOW_BID_LINE,0,value)){
        //--- display the error message in Experts journal
        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+-----------------------------------------------------------------------+
//| The function enables/disables the mode of displaying Ask line on the  |
//| chart.                                                                |
//+-----------------------------------------------------------------------+
bool ChartShowAskLineSet(const bool value,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_SHOW_ASK_LINE,0,value)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function enables/disables the mode of displaying vertical    |
//| separators between adjacent periods.                             |
//+------------------------------------------------------------------+
bool ChartShowPeriodSepapatorSet(const bool value,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_SHOW_PERIOD_SEP,0,value)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}

//+------------------------------------------------------------------+
//| The function enables/disables the chart grid.                    |
//+------------------------------------------------------------------+
bool ChartShowGridSet(const bool value,const long chart_ID=0){

    ResetLastError();

    if(!ChartSetInteger(chart_ID,CHART_SHOW_GRID,0,value)){

        Print(__FUNCTION__+", Error Code = ",GetLastError());
        return(false);
    }

    return(true);
}