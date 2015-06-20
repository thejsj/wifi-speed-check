#!/bin/sh

WIFI_NAME=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')

SPEED_RESULT=$(speedtest-cli)
RE_DOWNLOAD="Download: [0-9]*.[0-9]* Mbit/s"
RE_UPLOAD="Upload: [0-9]*.[0-9]* Mbit/s"
RE_NUMBER="[0-9]+.[0-9]+"
RE_HOST="Hosted by [A-z\. ]* \([A-z, ]*\) \[[0-9]+\.[0-9]+\ km\]"

# Download
if [[ $SPEED_RESULT =~ $RE_DOWNLOAD ]]; then
  MATCH=$BASH_REMATCH;
  if [[ $MATCH =~ $RE_NUMBER ]]; then
    DOWNLOAD_SPEED=$BASH_REMATCH;
  fi
else
  DOWNLOAD_SPEED=false
fi

# Upload
if [[ $SPEED_RESULT =~ $RE_UPLOAD ]]; then
  MATCH=$BASH_REMATCH;
  if [[ $MATCH =~ $RE_NUMBER ]]; then
    UPLOAD_SPEED=$BASH_REMATCH;
  fi
else
  UPLOAD_SPEED=false
fi

# Host
if [[ $SPEED_RESULT =~ $RE_HOST ]]; then
  MATCH=$BASH_REMATCH;
  echo $MATCH
  if [[ $MATCH =~ $RE_HOST ]]; then
    HOST=$BASH_REMATCH;
  fi
else
  HOST=false
fi

python -c "import rethinkdb as r; conn = r.connect(); r.db('internet').table('speeds').insert({ 'network': '$WIFI_NAME', 'host': '$HOST', 'download_speed': $DOWNLOAD_SPEED, 'upload_speed': $UPLOAD_SPEED, 'time': r.now() }).run(conn);"
