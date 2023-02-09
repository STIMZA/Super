
#include <sqlite.mqh>
#include <ChartBeautify.mqh>
#include <FileLog.mqh>

CFileLog *logger;

//######################################################################################################################

int historical_candles = 0;
string chart_symbol = "";

//######################################################################################################################

int OnInit(){
    logger = new CFileLog("SSV2_logs.log",TRACE,true);
    logger.Write("");
    logger.Trace("      ********************* Begin initialization of EA *********************");
    logger.Write("");
    logger.Write("               #####################################################");
    logger.Write("               #   SSV2 EA Copyright \x00A9 2022, all rights reserved   #");    
    logger.Write("               #    https://www.mql5.com/en/users/matimungoveni    #");
    logger.Write("               #       Developer : matimu.romeo@outlook.com        #");
    logger.Write("               #           A product of @SifuPriceAction           #");    
    logger.Write("               #####################################################");
    logger.Write("");
    ChartBackColorSet(clrWhite);
    ChartForeColorSet(clrBlack);
    ChartUpColorSet(clrBlack);
    ChartDownColorSet(clrBlack);
    ChartLineColorSet(clrWhite);
    ChartBullColorSet(clrWhite);
    ChartBearColorSet(clrBlack);
    ChartBidColorSet(clrDeepPink);
    ChartAskColorSet(clrBlue);
    ChartAutoscrollSet(true);
    ChartShiftSet(true);
    ChartModeSet(1);
    ChartShowBidLineSet(true);
    ChartShowAskLineSet(true);
    ChartShowPeriodSepapatorSet(false);
    ChartShowGridSet(false);

    if (!sqlite_init()) {
        return INIT_FAILED;
    }
    logger.Write("");
    logger.Write("");
    logger.Trace("      *********************  End initialization of EA  *********************");
    logger.Write("");
    logger.Write("");
    return INIT_SUCCEEDED;
}

//######################################################################################################################

void OnDeinit(const int reason){
    logger.Info(StringFormat("DeInitialising %d",reason));
    delete logger;
    sqlite_finalize();
}

//######################################################################################################################
                                            
bool do_check_table_exists (string db, string table){
   int res = sqlite_table_exists (db, table + "");
   if (res < 0) {
      PrintFormat ("Check for table existence failed with code %d", res);
      return (false);
   }
   return (res > 0);
}

void do_exec (string db, string exp){
    int res = sqlite_exec (db, exp + "");
    if (res != 0){
      PrintFormat ("Expression '%s' failed with code %d", exp, res);
    }
}

//######################################################################################################################

int start(){
   string database = "SSV2.db";
   
   ENUM_TIMEFRAMES period = ChartPeriod(0);
   string timeFrame = "";
   
   if(period == PERIOD_M1){
      timeFrame = "M1";
   }else if(period == PERIOD_M5){
      timeFrame = "M5";
   }else if(period == PERIOD_M15){
      timeFrame = "M15";
   }else if(period == PERIOD_M30){
      timeFrame = "M30";
   }else if(period == PERIOD_H1){
      timeFrame = "H1";
   }else if(period == PERIOD_H4){
      timeFrame = "H4";
   }else if(period == PERIOD_D1){
      timeFrame = "D1";
   }else if(period == PERIOD_W1){
      timeFrame = "W1";
   }else if(period == PERIOD_MN1){
      timeFrame = "MN1";
   }
   
   static int lastBar=0;
   
   if(lastBar!=Bars){
      
      chart_symbol = _Symbol;
      historical_candles = Bars; 
      lastBar=Bars;
      
      logger.Trace("----------- Begin per/bar information -----------"); 
            
      logger.Info(StringFormat("Symbol = %s", chart_symbol));      
      logger.Info(StringFormat("TimeFrame = %s", timeFrame));     
      logger.Info(StringFormat("Historical bars = %d", historical_candles));  
        
      logger.Trace("-----------  End per/bar information  -----------");
      logger.Write("");      
   }
   logger.Trace("______________________________________ TICK ______________________________________");           
   logger.Write("1. Checking if Component table exists in the database.");
   if (!do_check_table_exists (database, "Component")) {
      do_exec (database, "create table Component (" + "id integer NOT NULL PRIMARY KEY AUTOINCREMENT," +
               "description," + "start_month," + "start_week," + "start_day," + "start_hour," +
               "start_minute," + "start_seconds," + "clr," + "width," + "style," + "end_month," +
               "end_week," + "end_day," + "end_hour," + "end_minute," + "end_seconds," + "show_m1,"
               + "show_m5," + "show_m15," + "show_m30," + "show_h1," + "show_h4," + "show_d1,"
               + "show_w1," + "show_mn1)");
      logger.Write("    > Component table has been created.");
   }else{
      logger.Write("    > Component table already exists.");
   }
   
   int component_cols[25];
   
   int component_handle = sqlite_query (database, "select * from Component", component_cols);
   
   while (sqlite_next_row (component_handle) == 1) {
      logger.Write("2. Reading Component table..."); 
      TriggerComponent(sqlite_get_col(component_handle, 0), sqlite_get_col(component_handle, 1), 
                       sqlite_get_col(component_handle, 2), sqlite_get_col(component_handle, 3),
                       sqlite_get_col(component_handle, 4), sqlite_get_col(component_handle, 5), 
                       sqlite_get_col(component_handle, 6), sqlite_get_col(component_handle, 7),
                       sqlite_get_col(component_handle, 8), sqlite_get_col(component_handle, 9), 
                       sqlite_get_col(component_handle, 10), sqlite_get_col(component_handle, 11),
                       sqlite_get_col(component_handle, 12), sqlite_get_col(component_handle, 13), 
                       sqlite_get_col(component_handle, 14), sqlite_get_col(component_handle, 15),
                       sqlite_get_col(component_handle, 16), sqlite_get_col(component_handle, 17),
                       sqlite_get_col(component_handle, 18), sqlite_get_col(component_handle, 19),
                       sqlite_get_col(component_handle, 20), sqlite_get_col(component_handle, 21),
                       sqlite_get_col(component_handle, 22), sqlite_get_col(component_handle, 23),
                       sqlite_get_col(component_handle, 24), sqlite_get_col(component_handle, 25));
      
   }   
   sqlite_free_query (component_handle);
         
   logger.Trace("__________________________________________________________________________________");
   logger.Write("");   
   return 0;
}

//######################################################################################################################

string GenerateName(int component_identifier, string component_description){   
   string name;   
   name = component_description + "_" + getDate() + "_" + component_identifier;
   return name;
}

//######################################################################################################################

string getDate(){
   string ThisDate;   
   ThisDate = TimeToStr(TimeLocal(), TIME_DATE);      
   return ThisDate ;
}

//######################################################################################################################

void TriggerComponent(int component_id, string component_description, int component_start_month,
                      int component_start_week, int component_start_day, int component_start_hour, 
                      int component_start_minute, int component_start_seconds, int clr, int width, 
                      int style, int component_end_month, int component_end_week, int component_end_day, 
                      int component_end_hour, int component_end_minute, int component_end_seconds, string show_m1,
                      string show_m5, string show_m15, string show_m30, string show_h1, string show_h4, string show_d1, 
                      string show_w1, string show_mn1){
                      
   logger.Write("    > Triggering component : [" + GenerateName(component_id, component_description) + "]");
   
   int start_time = GetTimeInSec(component_start_month, component_start_week, component_start_day, 
                                 component_start_hour, component_start_minute, component_start_seconds);
   logger.Info("       - Start time : " + start_time + " | " + TimeToStr(start_time));
   int end_time = GetTimeInSec(component_end_month, component_end_week, component_end_day, 
                                 component_end_hour, component_end_minute, component_end_seconds);   
   logger.Info("       - End time : " + end_time + " | " + TimeToStr(end_time));
      
   ExecuteComponentTransaction(component_id, component_description, start_time, clr, width, style, end_time, show_m1, 
                               show_m5, show_m15, show_m30, show_h1, show_h4, show_d1, show_w1, show_mn1);
}

//######################################################################################################################

int GetTimeInSec(int month, int week, int day, int hour, int minutes, int seconds){   
   double time_in_seconds = 0;   
   int day_of_month = 0;
   int month_of_year = 0;   
   if(day == 0){
      day_of_month = Day();
   }else{
   
   }   
   if(month == 0){
      month_of_year = Month();
   }else{
   
   }   
   time_in_seconds = StrToTime(Year() + "." + month_of_year + "." + day_of_month + " " + hour + ":" + minutes + 
                               ":" + seconds);

   return time_in_seconds;
}

//######################################################################################################################

int GetNumberOfCandles(int start_time, int end_time, ENUM_TIMEFRAMES period){   
   int candles = 0;   
   candles = Bars(_Symbol, period, start_time, end_time);   
   return candles;
}

//######################################################################################################################

double getHighestPrice(int start_time, int end_time, string context, int component_candles, int position){
   int highest_candle = 0;
   if(context == "past"){
      highest_candle = iHighest(_Symbol, _Period, MODE_HIGH, component_candles, position);
   }else if(context == "current"){
      highest_candle = iHighest(_Symbol, _Period, MODE_HIGH, component_candles, 0);
   }            
   double highest_price = High[highest_candle];   
   return highest_price;  
}

//######################################################################################################################

double getLowestPrice(int start_time, int end_time, string context, int component_candles, int position){
   int lowest_candle = 0;
   if(context == "past"){
      lowest_candle = iLowest(_Symbol, _Period, MODE_LOW, component_candles, position);
   }else if(context == "current"){
      lowest_candle = iLowest(_Symbol, _Period, MODE_LOW, component_candles, 0);
   }      
   double lowest_price = Low[lowest_candle];   
   return lowest_price;
}

//######################################################################################################################

int CalculatePastCandlePosition(int end_time){
   
   int candle_position = 0;
   
   int p2 = 0;
   
   int current_time = StringToTime(TimeToString(TimeCurrent()));
   
   p2 = iBarShift(_Symbol, ChartPeriod(0), (current_time - (current_time - end_time) ));
   
   candle_position = p2;
   
   if(candle_position < 0){
      candle_position = candle_position * (-1);
   }
   
   return candle_position;   
}

//######################################################################################################################

void DrawComponent(int component_id, string component_description, int start_time, int clr, int width, int style, 
                   int end_time, double highest_price, double lowest_price, string show_m1, string show_m5, 
                   string show_m15, string show_m30, string show_h1, string show_h4, string show_d1, string show_w1, 
                   string show_mn1){
    
   ObjectDelete(GenerateName(component_id, component_description));   
   ObjectCreate(GenerateName(component_id, component_description), OBJ_RECTANGLE, 0, start_time, highest_price,
                             end_time, lowest_price);
   ObjectSet(GenerateName(component_id, component_description),OBJPROP_BACK,false);
   ObjectSet(GenerateName(component_id, component_description), OBJPROP_COLOR, clr); 
   ObjectSet(GenerateName(component_id, component_description), OBJPROP_STYLE, style);    
   ObjectSet(GenerateName(component_id, component_description), OBJPROP_WIDTH, width);
   ObjectSet(GenerateName(component_id, component_description), OBJPROP_SELECTABLE, false);
   ObjectSet(GenerateName(component_id, component_description),OBJPROP_BACK,false);  
   
   if(show_m1 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1);
   }
   
   if(show_m1 == "true" && show_m5 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5);
   }
   
   if(show_m1 == "true" && show_m5 == "true" && show_m15 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|
                OBJ_PERIOD_M15);
   }
   
   if(show_m1 == "true" && show_m5 == "true" && show_m15 == "true" && show_m30 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|
                OBJ_PERIOD_M15|OBJ_PERIOD_M30);
   }
   
   if(show_m1 == "true" && show_m5 == "true" && show_m15 == "true" && show_m30 == "true" && show_h1 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|
                OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
   }
   
   if(show_m1 == "true" && show_m5 == "true" && show_m15 == "true" && show_m30 == "true" && show_h1 == "true" &&
      show_h4 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|
                OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
   }
   
   if(show_m1 == "true" && show_m5 == "true" && show_m15 == "true" && show_m30 == "true" && show_h1 == "true" &&
      show_h4 == "true" && show_d1 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|
                OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1);
   }
   
   if(show_m1 == "true" && show_m5 == "true" && show_m15 == "true" && show_m30 == "true" && show_h1 == "true" &&
      show_h4 == "true" && show_d1 == "true" && show_w1 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|
                OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1);
   }
   
   if(show_m1 == "true" && show_m5 == "true" && show_m15 == "true" && show_m30 == "true" && show_h1 == "true" &&
      show_h4 == "true" && show_d1 == "true" && show_w1 == "true" && show_mn1 == "true"){
      ObjectSet(GenerateName(component_id, component_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|
                OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1|
                OBJ_PERIOD_MN1);
   }
}

//######################################################################################################################

void ExecuteComponentTransaction(int component_id, string component_description, int start_time, int clr, int width, 
                                 int style, int end_time, string show_m1, string show_m5, string show_m15, 
                                 string show_m30, string show_h1, string show_h4, string show_d1, string show_w1, 
                                 string show_mn1){
   
   int component_candles = 0;
   double highest_price = 0;
   double lowest_price = 0;
   int position = 0;
   
   if(StrToTime(TimeCurrent()) >= start_time && StrToTime(TimeCurrent()) <= end_time){
      component_candles = GetNumberOfCandles(start_time, end_time, ChartPeriod(0));
      highest_price = getHighestPrice(start_time, end_time, "current", component_candles, position);
      lowest_price = getLowestPrice(start_time, end_time, "current", component_candles, position);
      
      //logger.Write("3. Drawing Component...");
      DrawComponent(component_id, component_description, start_time, clr, width, 
                    style, end_time, highest_price, lowest_price, show_m1, show_m5, show_m15, show_m30, show_h1,
                    show_h4, show_d1, show_w1, show_mn1);
   }else if(StrToTime(TimeCurrent()) > end_time){
      component_candles = GetNumberOfCandles(start_time, end_time, ChartPeriod(0));
      position = CalculatePastCandlePosition(end_time);
      highest_price = getHighestPrice(start_time, end_time, "past", component_candles, position);
      lowest_price = getLowestPrice(start_time, end_time, "past", component_candles, position);
      
      //logger.Write("3. Drawing Component...");
      DrawComponent(component_id, component_description, start_time, clr, width, 
                    style, end_time, highest_price, lowest_price, show_m1, show_m5, show_m15, show_m30, show_h1,
                    show_h4, show_d1, show_w1, show_mn1);
   }else{
      //logger.Warning("Unable to determine the amount of candles contained in the component.");
   }
   logger.Write("    > Component calculations :");
   logger.Info(StringFormat("       - Number of candles = %d", component_candles ));
   logger.Info(StringFormat("       - If past component, candle position = %d", position));
   logger.Info(StringFormat("       - Highest price = %f", highest_price));
   logger.Info(StringFormat("       - Lowest price = %f", lowest_price));
}

