# BasicCleaner
A simple module designed to be a maintenance tool for devices that want to last a little longer, but don't want to do manual things to maintain the longevity of the device.

The script applies the following maintenance:

- fstrim every 7 days on: system, data, cache, persist, vendor, system_ext and product
- clean cache and trash of apps every 7 days.
- compile all apps in speed-profile every 7 days.
- zipalign every 15 days.
- vacuum, reindex, analyze and optimize the database every 15 days.
- synchronize the art, compile the images and do the final cleanup of unused files from the ART.
