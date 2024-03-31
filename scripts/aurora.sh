#!/bin/bash

# Geomagnetic Activity level

url="https://cdn.softservenews.com/southern_lights.html"
page=`w3m "$url" -dump | grep Activity`

B=10

echo -e "\n\033[2m    Aurora Watch\033[0m" #| lolcat -f -S 100 -tF .4
out="\033[2;34m Time,KPA,Percentage,Status\033[0m\n"

while read line; do

  when=`echo "$line" | grep -oP "in \d+" | cut -d' ' -f2`
  sec="`date +%s`"
  when=`echo "$sec" "$when" | awk '{print $1+60*$2}'`
  when=`date -R --date="@$when" | grep -oP '\s\d+:\d+'` # | sed 's/ //g'`

  kpa=`echo "$line" | grep -oP "\d\.\d+"`
  state=`echo "$line" | grep -oP "\w+$"`
  
  p=`echo "$kpa $B" | awk '{print (1) * $2*(1-(((8-$1)/8)^2)^.5)}' | cut -d. -f1`
  
  bar=""
  for ((i=0;i<$B;i++));do
	  [[ $p -gt $i ]] && bar=$bar'\033[33m+\033[0m' || bar=$bar'\033[2;30m+\033[0m'
  done

  out="$out""$when,$kpa,$bar,$state\n"

done <<< `echo "$page"`


echo -e "$out" | column -ts,

