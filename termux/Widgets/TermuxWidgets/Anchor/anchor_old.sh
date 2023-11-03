
cD='\033[2m'
cC='\033[0m'
cB='\033[34m'
cT='\033[36m'
cR='\033[31m'
cG='\033[32m'
cO='\033[33m'

M=1000000 # Multiplier to dodge non numeric format for low floating points, like  4.4593e-5

function origo() {
	ori="0 0"
	for i in `seq 1 $S`; do
		sample=` termux-location -p gps | grep lat -A1 | cut -f4 -d ' ' | sed 's/[,]//g' | tr -s '\n' ' ' `
		#echo "$ori" "$sample"
		ori=` echo $ori $sample $S | awk '{print $1+$3/$5" "$2+$4/$5}' `
		#echo "$ori" "$sample"
	done
	echo "$ori"
}

function magnitude() {
    mag=0
	for i in `seq 1 $S`; do
		sample=` termux-location -p gps | grep lat -A1 | cut -f4 -d ' ' | sed 's/[,]//g' | tr -s '\n' ' ' `
		#echo "A sample M: $A $sample $M"
		sample=` echo $A $sample $M $S | awk '{print ($5/$6)*(($1-$3)^2+($2-$4)^2)^.5}' `
		#echo "mag sample S: $mag $sample $S"
		mag=` echo $mag $sample $S | awk '{print $1+$2/$3}' `
		#echo "mag: $mag"
	done
	echo "$mag"
}

clear

echo
echo Anchor Guard `date +%H:%M:%S" "%F`
printf " $cB%s$cC $cD%s\b$cC" "Set interval in seconds:" "0" ; read I
printf " $cB%s$cC $cD%s\b$cC" "Set sample size:" "5" ; read S

if [[ -z $I ]]; then
	I=0
fi
if [[ -z $S ]]; then
	S=1
fi

printf "  $cG%s$cC " "Press enter when anchor drops" ; read
echo `date +%H:%M:%S` Fetching position

#A=` termux-location | grep lat -A1 | cut -f4 -d ' ' | sed 's/[,]//g' | tr -s '\n' ' ' `
A=` origo `
#echo "A: $A"
#echo `origo`

echo `date +%H:%M:%S` Anchor drop registered

sleep 1

printf "  $cG%s$cC " "Press enter when max stretched" ; read

echo `date +%H:%M:%S` Fetching position
#R=` termux-location | grep lat -A1 | cut -f4 -d ' ' | sed 's/[,]//g' | tr -s '\n' ' ' `
#echo "R coord: $R"
R=` magnitude `
echo `date +%H:%M:%S` Max radia registered
sleep 1

printf "  $cG%s$cC " "Press enter when engine's off to start monitoring" ; read
sleep 1

#R=` echo $A $R $M | awk '{print $5*(($1-$3)^2+($2-$4)^2)^.5}' ` #| cut -d e -f1 ` #| tr -d '.' `
#echo "R magn: $R"
R=` magnitude `
#echo "R magn: $R"

#R=0
#R=`magnitude`
#echo "R magn: $R"

echo

tput sc
C=0
tput civis

while [[ $(echo "if (${C} < ${R}) 1 else 0" | bc) -eq 1 ]]; do
	sleep $I
	#C=$(echo `magnitude` | awk '{print $1/10}')
	C=` magnitude `
#	echo `origo`
	#echo "C: $C"
	#for i in `seq 1 $S`; do
	#	c=` termux-location | grep lat -A1 | cut -f4 -d ' ' | sed 's/[,]//g' | tr -s '\n' ' ' `
	#	c=` echo $A $c $M $S | awk '{print ($5/(10*$6))*(($1-$3)^2+($2-$4)^2)^.5}' ` #| cut -d e -f1 ` # | tr -d '.'
	#	C=` echo $C $c $S | awk '{print $1+$2/$3}' `
	#done

	tput rc
	printf " $cT%s$cC %s  $cT%s$cC %s  $cT%s$cC %s \n" "Last record:" "`date +%H:%M:%S`" "Interval:" "$I seconds" "Samples:" "$S"

    #echo "C R: $C $R"
    #echo "@magnitude" ; magnitude
    #echo "magnitude: $(echo `magnitude` | awk '{print $1/10}')"
	Pper=` echo "$C" "$R" | awk '{print 100*$1/$2}' | cut -d . -f1 `
	Pbar=` echo "$Pper" | awk '{print  $1/2}' | cut -d . -f1 `

	for i in `seq 1 50`; do
		if [[ $Pbar -gt $i ]]; then
			printf ":"
		else
			printf "."
		fi
	done; echo " $Pper %  "

done

tput cnorm
echo

echo Potential drag !
termux-vibrate -d 5 -f
mpv OTH.mp3

