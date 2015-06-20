# Wifi Speed Test

This shell script is meant to run as a cron job in order to continually monitor WiFi speed. This is what you use when your property manager blames the internet company for slow speeds, when it's really an infrastructure issue.

## Setup

This script has 2 python dependencies and stores data in RethinkDB. You could easily switch this out to another database, since this is only one line.

```
pip install speedtest-cli rethinkdb
```

Run the cron job every 30 minutes (or as often as you want).

```
0,30 * * * * /Users/YOUR_USER_NAME/YOUR_PROJECTS/wifi-speed-check/wifi-speed-check.sh
```
