
#include <sqlite.mqh>
#include <ChartBeautify.mqh>
#include <FileLog.mqh>

CFileLog *logger;

int OnInit(){
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

   logger=new CFileLog("SuperSniper.log",TRACE,true);

   //logger.Write("Write message to log with no log level");
   //logger.Debug("Write Debug message to log");
   //logger.Warning("Write Warning message to log");
   //logger.Info("Write Info message to log");
   //logger.Error(StringFormat("Write Error message to log. Error at line %d",__LINE__));
   //logger.Critical("Write Critical message to log");

   if (!sqlite_init()) {
      return INIT_FAILED;
   }

   logger.Trace("--------- Initialization of SuperSniper EA completed.");

   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason){
   logger.Info(StringFormat("DeInitialising %d",reason));
   delete logger; // delete Chart Display
   sqlite_finalize();
}

int start(){
    static int lastBar=0;
    if(lastBar!=Bars){
        logger.Info(StringFormat("New Bar on Chart. Number of bars count in the history = %d",Bars));
        lastBar=Bars;
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

