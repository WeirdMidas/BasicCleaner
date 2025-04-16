#!/system/bin/sh
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# Wait some time... to apply cleaner script
sleep 120

# Configuration panel path
PANEL_FILE="/storage/emulated/0/Android/panel_execonfig.txt"

# pre-set configurations
if [ ! -e $PANEL_FILE ]; then
    echo "ZIPALIGN=1296000" > $PANEL_FILE
    echo "SQLITE=1296000" >> $PANEL_FILE
    echo "JUNK=604800" >> $PANEL_FILE
    echo "FSTRIM=604800" >> $PANEL_FILE
    echo "ART-PROFILE=604800" >> $PANEL_FILE
    echo "FINALCLEAN=2592000" >> $PANEL_FILE
fi

# Zipalign section
# Log file location
LOG_FILE=/storage/emulated/0/Android/zipalign.log

#Interval between ZipAlign runs, in seconds, 1296000 = 15 days
RUN_EVERY=$(grep "^ZIPALIGN=" $PANEL_FILE | cut -d'=' -f2)

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

    echo "Starting auto ZipAlign $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
    for apk in /data/app/*.apk ; do
        zipalign -c 4 $apk;
        ZIPCHECK=$?;
        if [ $ZIPCHECK -eq 1 ]; then
            echo ZipAligning $(basename $apk)  | tee -a $LOG_FILE;
            zipalign -f 4 $apk /cache/$(basename $apk);

            if [ -e /cache/$(basename $apk) ]; then
                cp -f -p /cache/$(basename $apk) $apk  | tee -a $LOG_FILE;
                rm /cache/$(basename $apk);
            else
                echo ZipAligning $(basename $apk) Failed  | tee -a $LOG_FILE;
            fi;
        else
            echo ZipAlign already completed on $apk  | tee -a $LOG_FILE;
        fi;
    done;
    echo "Auto ZipAlign finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
fi
#----------------------------------------------------------------------------------------------------------------------------

# SQLITE sectipn
# Log file location
LOG_FILE=/storage/emulated/0/Android/sq.log

#Interval between SQLite3 runs, in seconds, 1296000=15 days
RUN_EVERY=$(grep "^SQLITE=" $PANEL_FILE | cut -d'=' -f2)

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

    echo "SQLite database VACUUM, REINDEX, ANALYZE and OPTIMIZE started at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;

    for i in `find /d* -iname "*.db"`; do
        sqlite3 $i 'VACUUM;';
        resVac=$?
        if [ $resVac == 0 ]; then
            resVac="SUCCESS";
        else
            resVac="ERRCODE-$resVac";
        fi;

        sqlite3 $i 'REINDEX;';
        resIndex=$?
        if [ $resIndex == 0 ]; then
            resIndex="SUCCESS";
        else
            resIndex="ERRCODE-$resIndex";
        fi;
        
        sqlite3 $i 'ANALYZE;';
        resAnalyze=$?
        if [ $resAnalyze == 0 ]; then
            resAnalyze="SUCCESS";
        else
            resAnalyze="ERRCODE-$resAnalyze";
        fi;

        sqlite3 $i 'PRAGMA optimize;';
        resOptimize=$?
        if [ $resOptimize == 0 ]; then
            resOptimize="SUCCESS";
        else
            resOptimize="ERRCODE-$resOptimize";
        fi;

        echo "Database $i:  VACUUM=$resVac  REINDEX=$resIndex  ANALYZE=$resAnalyze  OPTIMIZE=$resOptimize" | tee -a $LOG_FILE;
    done

    echo "SQLite database VACUUM, REINDEX, ANALYZE, and OPTIMIZE  finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
fi;
#-----------------------------------------------------------------------------------

# Junk Cleaner
# Log file location
LOG_FILE=/storage/emulated/0/Android/junk.log

#Interval between Junk runs, in seconds, 604800 = 7 days
RUN_EVERY=$(grep "^JUNK=" $PANEL_FILE | cut -d'=' -f2)

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

	echo "Junk cleaner started at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "Remove junk files and app cache" | tee -a $LOG_FILE;

    rm -f /cache/*.apk
    rm -f /cache/*.tmp
    rm -f /cache/*.log
    rm -f /cache/*.txt
    rm -f /cache/recovery/*
    rm -f /data/*.log
    rm -f /data/*.txt
    rm -f /data/anr/*
    rm -f /data/backup/pending/*
    rm -f /data/cache/*
    rm -f /data/dalvik-cache/*.apk
    rm -f /data/dalvik-cache/*.tmp
    rm -f /data/dalvik-cache/*.log
    rm -f /data/dalvik-cache/*.txt
    rm -f /data/data/*.log
    rm -f /data/data/*.txt
    rm -f /data/log/*.log
    rm -f /data/log/*.txt
    rm -f /data/local/*.apk
    rm -f /data/local/*.log
    rm -f /data/local/*.txt
    rm -f /data/local/tmp/*
    rm -f /data/last_alog/*.log
    rm -f /data/last_alog/*.txt
    rm -f /data/last_kmsg/*.log
    rm -f /data/last_kmsg/*.txt
    rm -f /data/mlog/*
    rm -f /data/tombstones/*
    rm -f /data/system/*.log
    rm -f /data/system/*.txt
    rm -f /data/system/dropbox/*
    rm -f /data/system/usagestats/*.log
    rm -f /data/system/usagestats/*.txt
    rm -f /data/system/shared_prefs/*
    rm -f /data/vendor/wlan_logs/*
    rm -f /data/vendor/charge_logger/*
    rm -f /data/media/0/LOST.DIR
    rm -f /data/media/0/found000
    rm -f /data/media/0/LazyList
    rm -f /data/media/0/albumthumbs
    rm -f /data/media/0/kunlun
    rm -f /data/media/0/.CacheOfEUI
    rm -f /data/media/0/.bstats
    rm -f /data/media/0/.taobao
    rm -f /data/media/0/Backucup
    rm -f /data/media/0/MIUI/debug_log
    rm -f /data/media/0/ramdump
    rm -f /data/media/0/UnityAdsVideoCache
    rm -f /data/media/0/*.log
    rm -f /data/media/0/*.CHK
    rm -f /data/media/0/duilite
    rm -f /data/media/0/DkMiBrowserDemo
    rm -f /data/media/0/.xlDownload
    rm -f /data/media/0/Android/data/*/cache/*
    rm -f /data/data/com.whatsapp/files/Logs/whatsapp.log
    rm -f /data/data/com.myinsta.android/app_analytics/*
    rm -f /data/*/*/shared_prefs/com.crashlytics.prefs.xml
    rm -f /data/*/*/shared_prefs/com.google.android.gms.measurement.prefs.xml
    rm -f /data/*/*/shared_prefs/com.google.android.gms.analytics.prefs.xml
    rm -f /data/*/*/shared_prefs/com.google.firebase.crashlytics.xml
    rm -f /data/*/*/shared_prefs/admob.xml
    rm -f /data/*/*/shared_prefs/FBAdPrefs.xml
    rm -f /data/*/*/shared_prefs/crash_report.xml
    rm -f /data/*/*/shared_prefs/analyticsprefs.xml
	
	for dir in `find /data/data -type d -iname "*cache*"`; do
	find "$dir" -type f -delete
	done;
	
	echo "Junk cleaner finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "------------------------------------------------" | tee -a $LOG_FILE;
fi;
#-----------------------------------------------------------------------------------

# FSTRIM
# Log file location
LOG_FILE=/storage/emulated/0/Android/FSTRIM.log

#Interval between FSTRIM runs, in seconds, 604800 = 7 days
RUN_EVERY=$(grep "^FSTRIM=" $PANEL_FILE | cut -d'=' -f2)

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

	echo "fstrim started at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "Clean unnecessary fragments" | tee -a $LOG_FILE;

	fstrim -v /cache
	fstrim -v /data
	fstrim -v /system
	fstrim -v /persist
	fstrim -v /vendor
	fstrim -v /product
	fstrim -v /system_ext

	echo "fstrim finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "------------------------------------------------" | tee -a $LOG_FILE;
fi;
#-----------------------------------------------------------------------------------

# ART Compilation Section
# Log file location
LOG_FILE=/storage/emulated/0/Android/AppComp.log

#Interval between compilation runs, in seconds, 604800 = 7 days
RUN_EVERY=$(grep "^ART-PROFILE=" $PANEL_FILE | cut -d'=' -f2)

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

    echo "ART profile for user apps started at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
    echo "ART profile is applying" | tee -a $LOG_FILE;

    for app in $(pm list packages -3 | cut -f 2 -d ":"); do
        echo "Compiling $app..." | tee -a $LOG_FILE;
        pm compile -m speed-profile --full $app
    done
	
	echo "ART profile for user apps finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "------------------------------------------------" | tee -a $LOG_FILE;
fi;
#-----------------------------------------------------------------------------------

# ART Sincronization and Cleaning
# Log file location
LOG_FILE=/storage/emulated/0/Android/cleanART.log

#Interval between final cleaning runs, in seconds, 2592000 = 30 days
RUN_EVERY=$(grep "^FINALCLEAN=" $PANEL_FILE | cut -d'=' -f2)

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

	echo "ART Cleaning started at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "Clean unnecessary DEX files" | tee -a $LOG_FILE;

	pm reconcile-secondary-dex-files -a
    pm compile --compile-layouts -a
	pm art cleanup
	
	echo "ART Cleaning finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "------------------------------------------------" | tee -a $LOG_FILE;
fi;
