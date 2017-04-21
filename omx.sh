#!/bin/bash

echo "Enter URL (+ Prefered Format: [h]igh, [l]ow, [a]udio only)"
read LINK Q

if [ "$Q" = "h" ]; then
	omxplayer $(youtube-dl -gf 22 $LINK) -bo local
elif [ "$Q" = "l" ]; then
	omxplayer $(youtube-dl -gf 18 $LINK) -bo local
elif [ "$Q" = "a" ]; then
	omxplayer $(youtube-dl -gf 140 $LINK) -o local
else
	omxplayer $(youtube-dl -g $LINK) -bo local
fi
