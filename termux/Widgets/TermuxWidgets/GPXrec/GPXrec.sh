#!/bin/bash
#
echo GPX recorder | termux-toast

path="$HOME/TermuxWidgets/GPXrec/recs/"
file=$path`date +ride%m%d.gpx`
touch "$file"

termux-notification \
	-i 'log gpx' \
	-t 'Recording gpx' \
	-c 'Swipe when done' \
#	--on-delete 'bash gpxWrap'


function getTime() {
	date +%Y-%m-%dT%TZ
}

name=`date +Ride%m%d`
time=`getTime`

echo '<?xml version="1.0" encoding="UTF-8"?>
<gpx creator="MyTermux" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd" version="1.1" xmlns="http://www.topografix.com/GPX/1/1">'  > "$file"

echo "
 <metadata>
  <time>$time</time>
 </metadata>
 <trk>
  <name>$name</name>
  <type>cycling</type>
  <trkseg>
" >> "$file"


echo Recording starts | termux-toast

log=1
while [[ $log == 1 ]]; do
	printf '
	<trkpt lat="%s" lon="%s">
	<ele>%.1f</ele>
	<time>%s</time>
	</trkpt>\n' \
		`termux-location -r last | \
		jq -j '.latitude," ",.longitude," ",.altitude'` \
		"`getTime`" >> "$file"
	log=`termux-notification-list | jq .[].tag | grep -c 'log gpx'`
done

echo Recording ended | termux-toast

echo "
  </trkseg>
 </trk>
</gpx>
" >> "$file"

echo GPX recorded, see file "$file" | termux-toast

