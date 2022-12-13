
#include <sqlite.mqh>
#include <ChartBeautify.mqh>
#include <FileLog.mqh>

CFileLog *logger;

int OnInit(){
    logger=new CFileLog("SuperSniper.log",TRACE,true);

    //##################################################################################################################

    logger.Trace("--------- Begin initialization of SuperSniper EA.");

    ChartBackColorSet(clrWhite);
    ChartForeColorSet(clrBlack);
    ChartUpColorSet(clrBlack);
    ChartDownColorSet(clrBlack);
    ChartLineColorSet(clrBlack);
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

   //logger.Write("Write message to log with no log level");
   //logger.Trace("--------- Write Trace message to log.");
   //logger.Debug("Write Debug message to log");
   //logger.Warning("Write Warning message to log");
   //logger.Info("Write Info message to log");
   //logger.Error(StringFormat("Write Error message to log. Error at line %d",__LINE__));
   //logger.Critical("Write Critical message to log");

    if (!sqlite_init()) {
        return INIT_FAILED;
    }
    logger.Trace("--------- End initialization of SuperSniper EA.");

    //##################################################################################################################
    
    return INIT_SUCCEEDED;
}

enum BrokerZone{
   South_Africa = 1,
   United_Kingdom = 2,
   United_States = 3
};

void OnDeinit(const int reason){
    logger.Info(StringFormat("DeInitialising %d",reason));
    delete logger;
    sqlite_finalize();
}

input BrokerZone broker_GMT_type = 2;
input bool DaylightSavings = true;

int dls = 0;

int start(){
    string database = "SuperSniper.db";
    int monthId = 0;
    string monthName = "";
    int dayOfMonthId = 0;
    string dayOfMonthName = "";
    int hourOfDayId = 0;
    string hourOfDayName = "";
    int minuteOfHourId = 0;
    string minuteOfHourName = "";
    int dayOfWeekId = 0;
    string dayOfWeekName = "";
    
    if (!do_check_table_exists (database, "months")) {
        do_exec (database, "create table months (" + "id integer NOT NULL PRIMARY KEY AUTOINCREMENT," + "month)");
    }
    
    if (!do_check_table_exists (database, "daysOfMonth")) {
        do_exec (database, "create table daysOfMonth (" + "id integer NOT NULL PRIMARY KEY AUTOINCREMENT," + "day)");
    }
        
    if (!do_check_table_exists (database, "hoursOfDay")) {
        do_exec (database, "create table hoursOfDay (" + "id integer NOT NULL PRIMARY KEY AUTOINCREMENT," + "hour)");
    }
    
    if (!do_check_table_exists (database, "minutesOfHour")) {
        do_exec (database, "create table minutesOfHour (" + "id integer NOT NULL PRIMARY KEY AUTOINCREMENT," +
                           "minute)");
    }
    
    if (!do_check_table_exists (database, "daysOfWeek")) {
        do_exec (database, "create table daysOfWeek (" + "id integer NOT NULL PRIMARY KEY AUTOINCREMENT," + "day)");
    }
    
    if (!do_check_table_exists (database, "perimeter")) {
      do_exec (database, "create table perimeter (" + "id integer NOT NULL PRIMARY KEY AUTOINCREMENT," +
                         "description," + "start_month," + "start_week," + "start_day," + "start_hour," +
                         "start_minute," + "start_seconds," + "clr," + "width," + "style," + "end_month," +
                         "end_week," + "end_day," + "end_hour," + "end_minute," + "end_seconds)");
    }
      
    int months_cols[2],  daysOfMonth_cols[2], hoursOfDay_cols[2],  minutesOfHour_cols[2], daysOfWeek_cols[2],
        perimeter_cols[17];
   
    int months_handle = sqlite_query (database, "select * from months", months_cols);
    int daysOfMonth_handle = sqlite_query (database, "select * from daysOfMonth", daysOfMonth_cols);
    int hoursOfDay_handle = sqlite_query (database, "select * from hoursOfDay", hoursOfDay_cols);
    int minutesOfHour_handle = sqlite_query (database, "select * from minutesOfHour", minutesOfHour_cols);
    int daysOfWeek_handle = sqlite_query (database, "select * from daysOfWeek", daysOfWeek_cols);
    int perimeter_handle = sqlite_query (database, "select * from perimeter", perimeter_cols);
    
    while (sqlite_next_row (months_handle) == 1) {
        monthId = sqlite_get_col(months_handle, 0);
        monthName = sqlite_get_col(months_handle, 1);
        if(Month() == monthId){
            break;
        }
    }    
    sqlite_free_query (months_handle);
    
    while (sqlite_next_row (daysOfMonth_handle) == 1) {    
        dayOfMonthId = sqlite_get_col(daysOfMonth_handle, 0);
        dayOfMonthName = sqlite_get_col(daysOfMonth_handle, 1);        
        if(Day() == dayOfMonthId){
            break;
        }
    }    
    sqlite_free_query (daysOfMonth_handle);
        
    while (sqlite_next_row (hoursOfDay_handle) == 1) {
        hourOfDayId = sqlite_get_col(hoursOfDay_handle, 0);
        hourOfDayName = sqlite_get_col(hoursOfDay_handle, 1);
        if(Hour() == hourOfDayId){
            break;
        }
    }    
    sqlite_free_query (hoursOfDay_handle);
    
    while (sqlite_next_row (minutesOfHour_handle) == 1) {    
        minuteOfHourId = sqlite_get_col(minutesOfHour_handle, 0);
        minuteOfHourName = sqlite_get_col(minutesOfHour_handle, 1);        
        if(Minute() == minuteOfHourId){
            break;
        }
    }    
    sqlite_free_query (minutesOfHour_handle);
    
    while (sqlite_next_row (daysOfWeek_handle) == 1) {    
        dayOfWeekId = sqlite_get_col(daysOfWeek_handle, 0);
        dayOfWeekName = sqlite_get_col(daysOfWeek_handle, 1);        
        if(DayOfWeek() == dayOfWeekId){
            break;
        }
    }    
    sqlite_free_query (daysOfWeek_handle);
    
    while (sqlite_next_row (perimeter_handle) == 1) {
      TriggerPerimeter(sqlite_get_col(perimeter_handle, 0), sqlite_get_col(perimeter_handle, 1), 
                       sqlite_get_col(perimeter_handle, 2), sqlite_get_col(perimeter_handle, 3),
                       sqlite_get_col(perimeter_handle, 4), sqlite_get_col(perimeter_handle, 5), 
                       sqlite_get_col(perimeter_handle, 6), sqlite_get_col(perimeter_handle, 7),
                       sqlite_get_col(perimeter_handle, 8), sqlite_get_col(perimeter_handle, 9), 
                       sqlite_get_col(perimeter_handle, 10), sqlite_get_col(perimeter_handle, 11),
                       sqlite_get_col(perimeter_handle, 12), sqlite_get_col(perimeter_handle, 13), 
                       sqlite_get_col(perimeter_handle, 14), sqlite_get_col(perimeter_handle, 15),
                       sqlite_get_col(perimeter_handle, 16));
    }   
    sqlite_free_query (perimeter_handle);
    
    static int lastBar=0;
    if(lastBar!=Bars){
        logger.Trace("--------- Begin Per/Bar information.");        
        logger.Info(StringFormat("A new bar has printed. Historical bars = %d",Bars));
        logger.Info(StringFormat("Symbol = %s",_Symbol));
        
        //##############################################################################################################

        if(DayOfYear() >= 7 && DayOfYear() <= 355){
            logger.Info(StringFormat("Operational day of the year = %d",DayOfYear()));
            
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
            
            logger.Info(StringFormat("Chart time frame = %s",timeFrame));
            logger.Info("Machine time = " + TimeToString(TimeLocal()));
            logger.Info("Server time = " + TimeToString(TimeCurrent()));
            
            logger.Info(StringFormat("Year = %d",Year()));
                        
            if(Month() == monthId){
                logger.Info(StringFormat("Month = %d",monthId) + " (" + monthName + ")");
                
                if(Day() == dayOfMonthId){
                    logger.Info(StringFormat("Date = %d",Day()));

                    if(DayOfWeek() == dayOfWeekId){
                        string dayOfWeek = "";
                        
                        if(dayOfWeekId == 1){
                           dayOfWeek = "Monday";
                        }else if(dayOfWeekId == 2){
                           dayOfWeek = "Tuesday";
                        }else if(dayOfWeekId == 3){
                           dayOfWeek = "Wednesday";
                        }else if(dayOfWeekId == 4){
                           dayOfWeek = "Thursday";
                        }else if(dayOfWeekId == 5){
                           dayOfWeek = "Friday";
                        }
                        logger.Info(StringFormat("Day of week = %d",DayOfWeek()) + " (" + dayOfWeek + ")");

                        if(Hour() == hourOfDayId){
                            logger.Info(StringFormat("Hour of day = %d",Hour()));

                            if(Minute() == minuteOfHourId){
                                logger.Info(StringFormat("Minute of Hour = %d",Minute()));
                                
                                
                            }else{
                                logger.Error(StringFormat("Unable to determine the minute of hour. Error at line %d",
                                                           __LINE__));                                
                                
                            }
                        }else{
                            logger.Error(StringFormat("Unable to determine the hour of day. Error at line %d",
                                                       __LINE__));
                        }
                    }
                }else{
                    logger.Error(StringFormat("Unable to determine the day of month. Error at line %d",__LINE__));
                }
            }else{
                logger.Error(StringFormat("Unable to determine the month of year. Error at line %d",__LINE__) + " " +
                                                                                                    monthName);
            }

        }else{
            logger.Warning(
            "Holiday season. A time to reflect and startegise, system resumption will be on the 7th of Jan.");
        }

        //##############################################################################################################
        
        lastBar=Bars;

        logger.Trace("--------- End Per/Bar information.");
    }
    return 0;
}

//######################################################################################################################

                                            //DataBase Management
                                            
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

                                            //Time Management

int GetTimeInSec(int month, int week, int day, int hour, int minute, int seconds){
   
   double time_in_seconds = 0;
      
   int broker_GMT_offset = 0;
         
   if( IsTesting()){
      broker_GMT_offset = 0;
   }else if(broker_GMT_type == South_Africa){
      broker_GMT_offset = 2;
   }else if(broker_GMT_type == United_States){
      broker_GMT_offset = 6;
   }else if(broker_GMT_type == United_Kingdom){
      broker_GMT_offset = 1;
   }
   
   if(DaylightSavings == true){
      dls = 0;
   }else{
      dls = 1;
   }
   
   if(broker_GMT_type == United_States){
      time_in_seconds = StrToTime(Year() + "." + Month() + "." + Day() + " " + (hour + broker_GMT_offset - dls) + ":" + minute + ":" + seconds);
   }else if(broker_GMT_type == United_Kingdom || broker_GMT_type == South_Africa ){
      time_in_seconds = StrToTime(Year() + "." + Month() + "." + Day() + " " + (hour - broker_GMT_offset + dls) + ":" + minute + ":" + seconds);
   }
           
   return time_in_seconds;
}

//######################################################################################################################

                                            //Time Engineering

//######################################################################################################################

                                            //Capsuel

int CalculateRuler(string timeFrame){
   
   if(timeFrame == "M1"){
      
   }else if(timeFrame == "M5"){
      
   }else if(timeFrame == "M15"){
      
   }
   
   return 1;
}

//######################################################################################################################

                                            //Charting

void TriggerPerimeter(int perimeter_id, string perimeter_description, int perimeter_start_month,
                      int perimeter_start_week, int perimeter_start_day, int perimeter_start_hour, 
                      int perimeter_start_minute, int perimeter_start_seconds, int clr, int width, 
                      int style, int perimeter_end_month, int perimeter_end_week, int perimeter_end_day, 
                      int perimeter_end_hour, int perimeter_end_minute, int perimeter_end_seconds){
                             
   int start_time = GetTimeInSec(perimeter_start_month, perimeter_start_week, perimeter_start_day, 
                                 perimeter_start_hour, perimeter_start_minute, perimeter_start_seconds);
   
   int end_time = GetTimeInSec(perimeter_end_month, perimeter_end_week, perimeter_end_day, perimeter_end_hour, 
                               perimeter_end_minute, perimeter_end_seconds);
   
   int last_number_of_candles = GetLastNumberOfCandles(perimeter_id, perimeter_description, 
                                                       perimeter_start_month, perimeter_start_week, perimeter_start_day, 
                                                       perimeter_start_hour, perimeter_start_minute, 
                                                       perimeter_start_seconds);
   
   double highest_price = 0;
   double lowest_price = 0;
      
   if(StrToTime(TimeCurrent()) >= start_time && StrToTime(TimeCurrent()) <= end_time){
      
      highest_price = getHighestPrice(last_number_of_candles);
      lowest_price = getLowestPrice(last_number_of_candles);
        
      //break_out = CheckBreakOut(previous_session_highest_price, previous_session_lowest_price);
                  
      DrawPerimeter(perimeter_id, perimeter_description, start_time, clr, width, style, end_time, 
                    highest_price, lowest_price, last_number_of_candles);
   }  
}

int GetLastNumberOfCandles(int perimeter_id, string perimeter_description, int start_month, 
                           int start_week, int start_day, int start_hour, int start_minute, int start_seconds){
   
   ENUM_TIMEFRAMES period = ChartPeriod(0);
   
   int candles_lapsed = 0;
      
   if(period == PERIOD_M1){
      candles_lapsed = (GetTimeInSec(Month(), start_week, start_day, start_hour, start_minute, start_seconds)/60) - (GetTimeInSec(Month(), start_week, start_day, Hour(), Minute(), Seconds())/60);
   }else if(period == PERIOD_M5){
      candles_lapsed = (GetTimeInSec(Month(), start_week, start_day, Hour(), Minute(), Seconds())/300) - (GetTimeInSec(Month(), start_week, start_day, start_hour, start_minute, start_seconds)/300);
   }else if(period == PERIOD_M15){
      candles_lapsed = (GetTimeInSec(Month(), start_week, start_day, Hour(), Minute(), Seconds())/900) - (GetTimeInSec(Month(), start_week, start_day, start_hour, start_minute, start_seconds)/900);
   }else if(period == PERIOD_M30){
      candles_lapsed = (GetTimeInSec(Month(), start_week, start_day, Hour(), Minute(), Seconds())/1800) - (GetTimeInSec(Month(), start_week, start_day, start_hour, start_minute, start_seconds)/1800);
   }else if(period == PERIOD_H1){
      candles_lapsed = (GetTimeInSec(Month(), start_week, start_day, Hour(), Minute(), Seconds())/3600) - (GetTimeInSec(Month(), start_week, start_day, start_hour, start_minute, start_seconds)/3600);
   }else if(period == PERIOD_H4){
      candles_lapsed = (GetTimeInSec(Month(), start_week, start_day, Hour(), Minute(), Seconds())/14400) - (GetTimeInSec(Month(), start_week, start_day, start_hour, start_minute, start_seconds)/14400);
   }
   
   if(candles_lapsed < 0){
      candles_lapsed = candles_lapsed * (-1);
   }
   
   return candles_lapsed;
}

double getHighestPrice(int last_number_of_candles){
      
   int buffer = 1;
      
   int highest_candle = iHighest(_Symbol, _Period, MODE_HIGH, last_number_of_candles + buffer, 0);         
   double highest_price = NormalizeDouble(High[highest_candle], 2); 
   
   return highest_price;  
}

double getLowestPrice(int last_number_of_candles){
  
   int buffer = 1;
    
   int lowest_candle = iLowest(_Symbol, _Period, MODE_LOW, last_number_of_candles + buffer, 0);   
   double lowest_price = NormalizeDouble(Low[lowest_candle], 2);
   
   return lowest_price;
}

string GenerateName(int component_identifier, string component_description){   
   string name;   
   name = component_description + getDate() + "_" + component_identifier;
   return name;
}

string getDate(){
   string ThisDate;   
   ThisDate = TimeToStr(TimeLocal(), TIME_DATE);      
   return ThisDate ;
}



void DrawPerimeter(int perimeter_id, string perimeter_description, int start_time, color clr, int width, int style, 
                   int end_time, double highest_price, double lowest_price, int last_number_of_candles){
   
   logger.Trace("######### Begin draw perimeter #########");
   logger.Info(StringFormat("Perimeter Id = %d", perimeter_id));
   logger.Info(StringFormat("Perimeter description = %s", perimeter_description));
   logger.Info(StringFormat("Last number of candles = %d", last_number_of_candles));
   logger.Info(StringFormat("Start time = %d", start_time));
   logger.Info(StringFormat("End time = %d", end_time));
   logger.Info(StringFormat("Highest price = %f", highest_price));
   logger.Info(StringFormat("Lowest price = %f", lowest_price));
   logger.Trace("######### End draw perimeter #########");
    
   ObjectDelete(GenerateName(perimeter_id, perimeter_description));   
   ObjectCreate(GenerateName(perimeter_id, perimeter_description), OBJ_RECTANGLE, 0, start_time, highest_price, end_time, lowest_price);
   ObjectSet(GenerateName(perimeter_id, perimeter_description), OBJPROP_COLOR, clr); 
   ObjectSet(GenerateName(perimeter_id, perimeter_description), OBJPROP_STYLE, style);    
   ObjectSet(GenerateName(perimeter_id, perimeter_description), OBJPROP_WIDTH, width);
   ObjectSet(GenerateName(perimeter_id, perimeter_description), OBJPROP_SELECTABLE, false);
   ObjectSet(GenerateName(perimeter_id, perimeter_description),OBJPROP_BACK,false);  
   
   if(perimeter_description == "session_"){
      ObjectSet(GenerateName(perimeter_id, perimeter_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
   }else if(perimeter_description == "day_"){
      ObjectSet(GenerateName(perimeter_id, perimeter_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
   }else if(perimeter_description == "week_"){
      ObjectSet(GenerateName(perimeter_id, perimeter_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
   }else if(StringSubstr(perimeter_description, 0, 14) == "fifteen_minute"){
      ObjectSet(GenerateName(perimeter_id, perimeter_description),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1);
   }
       
   ObjectSet(GenerateName(perimeter_id, perimeter_description),OBJPROP_BACK,false);
}
