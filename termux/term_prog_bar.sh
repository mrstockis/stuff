#!/bin/bash

cGreen='\033[32m' ; cG=$cGreen
cYellow='\033[33m'; cY=$cYellow
cRed='\033[31m'   ; cR=$cRed
fClear='\033[0m'  ; fC=$fClear


function bar() {
	let pro=$1
	let con=$2
	let total=pro+con
	let rate=(pro*100)/total
	let tens=rate/10
	
	ca=`[ 5 -le $(( rate-tens*10 )) ] && echo 1 || echo 0`

	printf " $cGreen%s$cYellow%s$cRed%s$fClear %5s" \
		"`for i in $( seq 1 $tens ); do printf "-"; done`" \
		"`for i in $( seq 1 $ca ); do printf "-"; done`" \
		"`for i in $( seq $((tens+ca)) 9 ); do printf "-"; done`" \
		"$rate% "
}

pbar() {
#    ' ---------- dd% '
init=` printf "%-17s" `
title=` printf " \033[2;36m%s$fC |$init" "$1" `
comment=` printf "\033[2m%-34s" "  $2" `

back="\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"        #`echo $init | sed 's/ /\\b/g'`

printf "$title$comment$back$back"

for i in $(seq 0 99); do 
	printf "$back%s" "`bar $i $((99-i))`"
	sleep .001
done; echo
}

function progress() {
declare -i down=0
#    ' ---------- dd% '
init="                "
back="`echo $init | sed 's/ /\\b/g'`"
until [ -e 140.m4a.part ] || [ -e 140.m4a ]; do sleep 1; done

printf "          "
while [ -e 140.m4a.part ]; do
 let down=` ls -l 140.m4a.part | awk '{print $5}' `
 let left=${info[size]}-$down
 printf "$back%s" "`bar $down $left`"
 sleep 5
done
#wait
printf "$back"; bar 100 0; echo
}


secToHMS() {
let T=$1
let H=T/3600; let T=T-3600*H
let M=T/60; let T=T-60*M
let S=T; HMS=($H $M $S); fHMS=()
for t in ${HMS[@]}; do
 [ $t -gt 0 ] && fHMS+=(`[ $t -lt 10 ] && echo 0`$t)
done
echo ${fHMS[@]} | sed 's/ /:/g'
}


declare -A info=(
 [all]=''
 [url]='.webpage_url'
 [title]='.title'
 [duration]='.duration'
 [likes]='.like_count'
 [nlikes]='.dislike_count'
 [views]='.view_count'
 [audio]='.formats | .[] | select(.format_id == "140") | .url'
 [size]='.formats | .[] | select(.format_id == "140") | .filesize'
)


function download() {
json=` youtube-dl -j $1 `

for i in "${!info[@]}"; do
 info[$i]=`echo $json | jq -r "${info[$i]}"`
done

printf "%s [%s]" "${info[title]}" "`secToHMS ${info[duration]}`"
#"`bar ${info[likes]} ${info[nlikes]}`"

youtube-dl -qo "140.m4a" "${info[audio]}" &
}



## START
echo "PROGRESS "; sleep 2
echo;echo " // alone"
pbar
echo;echo " // with title"
pbar " start"
echo;echo " // with comment"
pbar "Here we go" "now look at that"
echo;echo " // appended to string"
printf " Downloading the"
pbar "Answer" "to ~/Life/Universe/Everything/"
read

exit

sample="https://www.youtube.com/watch?v=JRfuAukYTKg"

echo; echo
echo by rawyson - with progressbar
echo
#time (download "$sample"; progress)
wait; rm 140.m4a

exit

echo; echo
echo by rawyson - without progressbar
echo
time (download "$sample")
wait; rm 140.m4a

exit
clear


#ysondata=`youtube-dl https://youtu.be/JRfuAukYTKg -j`
#ysondata=`youtube-dl https://www.youtube.com/watch?v=xoirXUhEpIo -j`
ysondata=`cat ysondata`



exit
function getInfo() {
	link=$1
	
	ysondata=`youtube-dl $link -j`
	likes=`echo $both | cut -d' ' -f1 | sed 's/,//g' `
	dislikes=`echo $both | sed 's/,//g' | awk '{print $2}' `

        like_bar=`bar $likes $dislikes`
	(echo -e "$fBright$title$fClear" &&
		printf "Likes $like_bar " &&
		echo -e $rate% &&
		echo "$info") | less -r
	))
}



