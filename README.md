# BasicCleaner
A simple module designed to be a maintenance tool for devices that want to last a little longer, but don't want to do manual things to maintain the longevity of the device.

The script applies the following maintenance after 2min of boot:

- fstrim every 7 days on: system, data, cache, persist, vendor, system_ext and product. 
- clean cache and trash of apps every 7 days.
- compile all apps in speed-profile every 7 days.
- zipalign every 15 days.
- vacuum, reindex, analyze and optimize the database every 15 days.
- synchronize the art, compile the images and do the final cleanup of unused files from the ART every 30 days.

If you want logs, just go to the android folder in the main storage. It will show all the cleanings applied, the time it took between them, etc.

## Customizing the cleaning time

The module has now been updated and you can customize the cleaning period for each task. This is done in the file called "panel_execonfig", which is located in the android folder where the cleaning logs are located. The way to customize it is through seconds, where you will enter the time of the day in seconds (example: 15 days for optimization of compiling apps in speed-profile would give 1296000). It is recommended to NEVER set it to less than 5 days (or even 7 depending) because this can cause "overcleaning", which can affect your system by leaving it so clean that it can generate errors, such as messengers frequently disappearing messages, or even the corruption of the database of some of your applications (if you force the sqlite optimization too much).

- Default Values ​​(And their Meanings)
  - ZIPALIGN=1296000 (Zipalign)
  - SQLITE=1296000 (Database)
  - JUNK=604800 (Cache and Junk of apps)
  - FSTRIM=604800 (Fstrim)
  - ART-PROFILE=604800 (Speed-profile for user apps)
  - FINALCLEAN=2592000 (Sincronyze, compile the XML images and Clean of unused files from ART)

## WARNING!
The module also comes with the latest version of the sqlite binary, which is a maintenance that I will do to keep the module up to date. So if you use a module that also does this, I recommend removing it, or not using my module.

Older Androids can also suffer from the updated sqlite, so have your bootloop protection module on hand, in case something goes wrong.

Another warning: The first time you install the module and in the next cleanings, it will apply the cleaning, so LET THE MODULE DO ITS WORK! DON'T DISTURB IT BY USING YOUR PHONE WHILE IT CLEANS! This prevents the script from doing something wrong and even corrupting one of your applications because of YOU! Anyway, let the module do the cleaning first, it takes almost no time and trust me, it's better because it even maximizes the cleaning.
