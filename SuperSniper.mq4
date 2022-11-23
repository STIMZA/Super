
#include <sqlite.mqh>
#include <ChartBeautify.mqh>

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

   if (!sqlite_init()) {
      return INIT_FAILED;
   }
   
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason){
   sqlite_finalize();
}

int start(){


   
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

