#!/system/bin/sh
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# Wait some time... to apply cleaner script
sleep 120

# Configuration panel path
PANEL_FILE="/storage/emulated/0/Android/panel_cleancfg.txt"

# pre-set configurations
if [ ! -e $PANEL_FILE ]; then
    echo "# Welcome to the Basic Cleaner simple configuration file" > $PANEL_FILE
    echo "# here you can configure the time between cleanings, feel free to make your changes." >> $PANEL_FILE
    echo "ZIPALIGN=1296000" >> $PANEL_FILE
    echo "JUNK=604800" >> $PANEL_FILE
    echo "FSTRIM=604800" >> $PANEL_FILE
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
            zipalign -v 4 $apk /cache/$(basename $apk);

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
	rm -f /data/anr/*.log
	rm -f /data/anr/*.txt
	rm -f /data/backup/pending/*.tmp
	rm -f /data/cache/*.*
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
	rm -f /data/local/tmp/*.log
	rm -f /data/local/tmp/*.txt
	rm -f /data/last_alog/*.log
	rm -f /data/last_alog/*.txt
	rm -f /data/last_kmsg/*.log
	rm -f /data/last_kmsg/*.txt
	rm -f /data/mlog/*
	rm -f /data/tombstones/*.log
	rm -f /data/tombstones/*.txt
	rm -f /data/system/*.log
	rm -f /data/system/*.txt
	rm -f /data/system/dropbox/*.log
	rm -f /data/system/dropbox/*.txt
	rm -f /data/system/usagestats/*.log
	rm -f /data/system/usagestats/*.txt
	
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
	cmd package bg-dexopt-job 
	
	echo "ART Cleaning finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "------------------------------------------------" | tee -a $LOG_FILE;
fi;
