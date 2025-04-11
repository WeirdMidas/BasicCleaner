# BasicCleaner
A simple module designed to be a maintenance tool for devices that want to last a little longer, but don't want to do manual things to maintain the longevity of the device.

The script applies the following maintenance after 2min of boot:

- fstrim every 7 days on: system, data, cache, persist, vendor, system_ext and product.
- clean cache and trash of apps every 7 days.
- compile all apps in speed-profile every 7 days.
- zipalign every 15 days.
- vacuum, reindex, analyze and optimize the database every 15 days.
- synchronize the art, compile the images and do the final cleanup of unused files from the ART.

If you want logs, just go to the android folder in the main storage. It will show all the cleanings applied, the time it took between them, etc.

## WARNING!
The module also comes with the latest version of the sqlite binary, which is a maintenance that I will do to keep the module up to date. So if you use a module that also does this, I recommend removing it, or not using my module.

Older Androids can also suffer from the updated sqlite, so have your bootloop protection module on hand, in case something goes wrong.
