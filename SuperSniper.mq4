
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

void OnDeinit(const int reason){
    logger.Info(StringFormat("DeInitialising %d",reason));
    delete logger;
    sqlite_finalize();
}

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
      
    int months_cols[2],  daysOfMonth_cols[2], hoursOfDay_cols[2],  minutesOfHour_cols[2], daysOfWeek_cols[2];
   
    int months_handle = sqlite_query (database, "select * from months", months_cols);
    int daysOfMonth_handle = sqlite_query (database, "select * from daysOfMonth", daysOfMonth_cols);
    int hoursOfDay_handle = sqlite_query (database, "select * from hoursOfDay", hoursOfDay_cols);
    int minutesOfHour_handle = sqlite_query (database, "select * from minutesOfHour", minutesOfHour_cols);
    int daysOfWeek_handle = sqlite_query (database, "select * from daysOfWeek", daysOfWeek_cols);
    
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

int GetTimeInSec(int year, int month, int day, int hour, int minute, int seconds){
   int time_in_seconds = 0;
   time_in_seconds = StrToTime(year + "." + month + "." + day + " " + hour + ":" + minute + ":" + seconds);
   return time_in_seconds;
}

int GetCurrentTime(){
   int currentTime = 0;
   currentTime = GetTimeInSec(Year(), Month(), Day(), Hour(), Minute(), Seconds());
   return currentTime;
}

int GetPastTime(int yearsToSubtract, int monthsToSubtract, int daysToSubtract, int hoursToSubtract,
                int minutesToSubtract, int secondsToSubtract){
    int pastTime = 0;
    pastTime = GetTimeInSec((Year() - yearsToSubtract), (Month() - monthsToSubtract), (Day() - daysToSubtract),
                            (Hour() - hoursToSubtract), (Minute() - minutesToSubtract),
                            (Seconds() - secondsToSubtract));
    return pastTime;
}

int GetFutureTime(int yearsToAdd, int monthsToAdd, int daysToAdd, int hoursToAdd, int minutesToAdd, int secondsToAdd){
    int pastTime = 0;
    pastTime = GetTimeInSec((Year() + yearsToAdd), (Month() + monthsToAdd), (Day() + daysToAdd), (Hour() + hoursToAdd),
                            (Minute() + minutesToAdd), (Seconds() + secondsToAdd));
    return pastTime;
}

//######################################################################################################################

                                            //Time Engineering

