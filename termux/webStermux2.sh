#!/bin/bash
#############################################################
clear				##Clear terminal at start
N="instrumental"		##Default playlist at start
n=$N
Dir=~/".webSound/"		##Location of webSound.sh
Local=$Dir"local/"
Nhits=20			##Number of hits from youtube search
editor="vim"
player="mpv --vid=no --really-quiet" #"--load-unsafe-playlists"	##LUP-flag fixes mpv refusing playback of playlist
#player="omxplayer -o local --vol -900"
#############################################################


# \033[ brightness ; colortext ; colorbackground m :: \033[ [0-2] ; 3[0-9] ; 4[0-9] m
# \033[1;32;44m  :: bright green text, on blue background
# \033[0m        :: return to white text on transparent background

declare -A c
	c5[B]="\033[1m"; c[D]="\033[2m"; c[E]="\033[0m"
	c[y]="\033[33m"; c[r]="\033[31m";
	c[g]="\033[32m"; c[b]="\033[34m"
	c[Er]="\033[1;39;41m"
	c[ws]=" w e b s o u n d"; c[lo]=" l o c a l"
	c[yt]=" y o u t u b e"; c[sc]=" s o u n d c l o u d"
	c[bad]=" No proper command. Enter 'h' for help"
	#c[dot]="---------------------------"
	c[dot]="-----------------------"

declare -A C
	C[initial]="${c[B]}${c[b]}${c[ws]}${c[E]}\n\n"
	C[default]="${c[b]}${c[ws]}${c[E]}\n\n"
	C[youtube]="${c[B]}${c[r]}${c[yt]}${c[E]}\n\n"
	C[soundcloud]="${c[y]}${c[sc]}${c[E]}\n\n"
	C[Local]="${c[g]}${c[lo]}${c[E]}\n"
	C[saving]="${c[b]}Saving${c[E]}"
	C[to]="${c[b]}to${c[E]}"
	C[state0]="${C[B]}${c[y]}state${c[E]}"
	C[state1]="\b\b\b\b\b${c[g]}state${c[E]}"
	C[nProp]="${c[Er]}${c[bad]}${c[E]}\n\n"


fBright="\033[1m"; fDark="\033[2m"; fClear="\033[0m"
cYellow="\033[33m"; cRed="\033[31m";
cGreen="\033[32m"; cBlue="\033[34m"
cError="\033[1;39;41m"; sError=" No proper command. Enter 'h' for help"
sMain=" w e b s o u n d"; sLocal=" l o c a l"
sYoutube=" y o u t u b e"; sSoundcloud=" s o u n d c l o u d"
sDots="-----------------------"

fInitial="$fBright$cBlue$sMain$fClear\n\n"
fDefault="$cBlue$sMain$fClear\n\n"
fYoutube="$fBright$sRed$sYoutube$fClear\n\n"
fSoundcloud="$cYellow$sSoundcloud$fClear\n\n"
fLocal="$cGreen$sLocal$fClear\n"
fSaving="${c[b]}Saving${c[E]}"  #this is dumb
fTo="${c[b]}to${c[E]}"          # same
fState0="${C[B]}${c[y]}state${c[E]}"
fState1="\b\b\b\b\b${c[g]}state${c[E]}\n"
fWrong="${c[Er]}${c[bad]}${c[E]}\n\n"

help=(""
" SYNTAX: [First] (Second)"
""
" [h]   →  This help"
""
" [URL] →  Play [URL]"
" [y]   →  Search youtube"
" [s]   →  Search soundcloud"
" [d]   →  Go to downloaded"
" [p]   →  Play through active playlist"
" [r]   →  Read current playlist"
" [l]   →  List all playlists"
" [e]   →  Edit playlist"
""
" [URL] (a)         → (a)dd [URL] to current playlist"
" [SearchTerm] (p)  → (p)lay match from playlist"
" [SearchTerm] (k)  -> remove match from playlist"
" [ListName] (l)    →  choose playlist [ListName]"
" [ListName] (L)    →  create playlist [ListName]"
" [ListName] (K)    →  delete playlist [ListName]"
""
" <Enter> to leave active mode "
" <Enter> (double tap) to exit program "
" <q> exits active media <ctrl+c> stops script"
""
" Some preferences(player,editor,etc.) can be made "
" by editing top-section of the script '.webSound.sh'"
"")


function Home() {
	Head "${C[default]}"
}
function Info() {
	printf "${c[d]} $N{`grep '|' -c $Dir$N`}\n${c[dot]}${c[E]}\n"
}
function Head() {
	clear
	[ -z "$1" ] && printf "${C[default]}" || printf "$1\n"
}

play() {
	sleep 10; Head &
	$player "$1"
}

function Add() {
	#E=`printf "$(youtube-dl --flat-playlist -e "$1")\n" | head -n 1`

	#if [ ! "$E" ]; then E="Playlist?"; fi

	#printf "\n|$E\n"$1"\n" >> $Dir$N
	#printf " ${c[b]}Added:${c[E]}  $E\n    ${c[b]}To:${c[E]}  $N\n"

	title="$1" ; link="$2"
	[ -z "$link" ] &&
		link="$1" &&
		printf " Grabbing title..\r" &&
		title=` youtube-dl -e "$1" `
	

	printf "\n|$title\n$link\n" >> $Dir$N
	printf " ${c[b]}Added:${c[E]}  $title\n    ${c[b]}To:${c[E]}  $N\n"
	read -p " .."
}


function Download() {
	#title=`youtube-dl -e $1`
	#name=`printf "$title\n" | sed 's/\ /_/g'`
	#printf " ${C[saving]} $title\n ${C[to]} $Local ... "
	#state 0
	#youtube-dl -qo $Local$name -f bestaudio $1
    	#printf "\n|$title\n$Local$name\n" >> $Dir"llocal"
	#state 1
	
	title=$1
	fname=`printf "$title\n" | sed 's/\ /_/g'`
	printf " ${C[saving]} $title\n ${C[to]} ~/.webSound/local/ ... "
	#echo $fname
	state 0
	youtube-dl -qo $Local$fname -f bestaudio $2
    	printf "\n|$title\n$Local$fname\n" >> $Dir"llocal"
	state 1
	read -p " .."
}


function state() {
	#if [ $1 == 0 ]; then
		#state="${C[state0]}"
	#else
		#state="${C[state1]}"
	#fi
	#printf $state

	[ $1 -eq 0 ] && printf "$fState0" || printf "$fState1"

}


function YTsearch() {
	while true; do #clean "${C[youtube]}"
		read -rep ' Search: ' s
		history -s "$s"

		if [ ! "$s" ]; then Head; break
		else
			S="`echo "$s" | sed 's/\ /+/g'`"
			w3m -dump -o display_link_number=1 https://www.youtube.com/results?search_query="$S" |
			grep -e "- Duration" | grep '\[' | 
			sed 's/[ \t]*//' | sed 's/]/ \t/' | sed 's/\[//' | sed 's/ Duration://' |
			head -n "$Nhits"
			#grep "Play now" -A 2 |
			#grep "\[" |
			#sed 's/[ \t]*//' |
			#sed 's/ Duration://' |
			#head -n "$Nhits"

			while true; do read -rep ' n (a|d): ' P A

				if [ ! "$P" ]; then break; fi

				link=`w3m -dump -o display_link_number=1 https://www.youtube.com/results?search_query="$S" |
					grep "References:" -A 200 |
					grep "\["$P"\]" |
					awk '{print $2}' `

				if [ ! "$A" ]; then
					$player $link

				elif [ "$A" == "a" ]; then
					Add $link

				elif [ "$A" == "d" ]; then
					Download "$link"

				else
					printf " [Number]	→ play choice\n [Number] (a|d)	→ add/download choice\n [empty]	→ back to search\n"

				fi
			done
		fi
	done
	main
}


function SCsearch(){
	while true; do #clean "${C[soundcloud]}"  # Title
		read -rep ' Search: ' s
		history -s "$s"

		if [ ! "$s" ]; then break #Top; break
		else
			S=`echo "$s" | sed 's/\ /+/g'`
			w3m -dump -o display_link_number=1 https://soundcloud.com/search?q=$S |
			grep "\[7\]" -A 30 |
			sed 's/[ \t• ]*//' |
			grep "\]" |
			head -n 10

			while true; do read -rep ' n (a|d): ' P A

				if [ ! "$P" ]; then break; fi

				link=`w3m -dump -o display_link_number=1 https://soundcloud.com/search?q="$S" |
					grep "References:" -A 200 |
					grep "\["$P"\]" |
					awk '{print $2}' `

				if [ ! "$A" ]; then
					$player $link

				elif [ "$A" == "a" ]; then
					Add $link

				elif [ "$A" == "d" ]; then
					Download "$link"

				else
					printf " [Number]	→ play choice\n [Number] (a|d)	→ add/download choice\n [empty]	→ back to search\n"

				fi
			done
		fi
	done
}


function Search() {
sc='https://soundcloud.com/search?q='
yt='https://www.youtube.com/results?search_query='
base=`[ $1 == s ] && echo "$sc" || ([ $1 == y ] && echo "$yt")`
domain=`[ $1 == s ] && printf "${C[soundcloud]}" || ([ $1 == y ] && printf "${C[youtube]}")`

while true; do Head "$domain\n" #SearchLoop

read -rep " Search: " S
[ -z "$S" ] && Head && return
history -s $S

S=`echo $S | sed 's/\ /+/g'`
dump=`w3m -dump -o display_link_number=1 "$base""$S"`

hits=`echo "$dump" |
	grep -e "- Duration" |
	grep '\[' |
	sed 's/[ \t]*//' |
	sed 's/]/ \t/' |
	sed 's/\[//' |
	sed 's/ Duration://' |
	head -n "$Nhits" 
	`

#echo
lhits=`echo "$hits" | cut -d ' ' -f2- | grep -nE '.' `
#echo "$lhits"
#echo

declare -A refs; c=1
for r in `echo "$hits" | cut -d ' ' -f1`; do
	refs[$c]=$r
	((c++))
done

while true; do #PickLoop
Head "$domain"
echo; echo "$lhits"; echo
read -rep " n a|d|i: " U A Q
[ -z $U ] && break

r="\[${refs[$U]}\]"
link=`
	echo "$dump" |
	grep "References:" -A200 |
	grep "$r" |
	awk '{print $2}'
	`

title=`
	echo "$dump" |
	grep -e "- Duration:" |
	grep $r |
	cut -d ']' -f2 |
	sed 's/Duration: //'
	`
nfield=`printf "$(echo $title | sed 's/-/\\n/g')" | wc -l`
title=`echo "$title" | cut -d'-' -f-$nfield`


[ -z "$A" ] && (
 echo -e "\n$cBlue Playing$fClear $title"
 $player $link
)
[ "$A" ] &&
([ "$A" == "a" ] && Add "$title" "$link") ||
([ "$A" == "d" ] && Download "$title" "$link") ||
([ "$A" == "v" ] && playVideo "$title" "$link" "$Q") ||
([ "$A" == "i" ] && getInfo "$link") ||
([ "$A" == "l" ] && printf " $title\n $link\n" && read -p " ..") ||
printf " [Number] \t → play choice\n [Number] (a|d|i) \t → add/download choice\n [empty] \t → back to search\n"

done #PickLoop
done #SearchLoop

Head; main

}


function Local() {
    n=$N
    N="llocal"

    while true; do Head "${C[Local]}"
        grep '|' $Dir$N
        
        read -rep " RegX: " U A
        
        if [[ -z "$U" ]]; then
            break
        elif [ -z "$A" ]; then
            if [ "$U" == "e" ]; then 
				$editor $Dir$N
            else
                playSpecific "$U"
                #Local
            fi
       
        #!use regex to find link to file and remove its path, and then rewrite playlist, excluding that match!
		elif [ "$A" == "k" ]; then
		    removeElement "$U"
		    clear
		    #Local
        fi
    done
    
    N=$n
	
    # Select
    
    Head; main
}


#function Select() {
#	declare -A items
#	count=1
#	for i in `ls $Local`; do
#		echo "$count: $i"
#		items[$count]="$i"
#		count=$((count+1))
#	done
#	echo
#	while true; do
#		read -rep " n (r): " U A
#		if [ -z "$U" ]; then
#			break
#		elif [ -z "$A" ]; then
#			$player $Local${items[$U]}
#			Local
#		else
#			if [ "$A" == "r" ]; then
#				rm $Local${items[$U]}
#				Local
#			else
#				printf "\n${C[nProp]}"; fi
#		fi
#	done
#}


function playAll() {
	printf "${c[b]} @$N ${c[E]}\n"
	printf "${c[b]}`grep '|' $Dir$N | cut -d"|" -f1-`${c[E]}\n"
	$player `grep -v '|' $Dir$N` 2>/dev/null
}


function playSpecific() {
    expr='\|.*'$1
    history -s "$1"
    printf "` grep -E $expr -i $Dir$N `" | grep "|"
    $player ` grep -E $expr -i $Dir$N -A 1 | grep -v "|" `
    Head
    #if [ ! "`grep -i $1 $Dir$N | grep '|'`" ]; then
	#	printf "${c[b]}`grep -i $1 $Dir$N`${c[E]}\n\n"
	#	$player `grep -i $1 $Dir$N` 2>/dev/null
	#else
	#	f=(); f+=(`grep -iA 1 $1 $Dir$N | egrep -v '\|'`)
	#	printf "${c[b]}`grep -i $1 $Dir$N`${c[E]}\n\n"
	#	$player ${f[@]} 2>/dev/null
	#fi
}


function playLink() {
	if (echo $1 | grep /); then
		echo "Grabbing content.."
		E=`youtube-dl --flat-playlist -e $1 2>/dev/null`
		Head
		printf "${c[b]} $E ${c[E]}\n"
		$player $1 2>/dev/null
	else
		printf "${C[nProp]}"
	fi
}


function getLink() {
    expr='\|.*'$1
    #history -s "$1"
    grep -E $expr -i $Dir$N -A 1 | grep -v "|" | head -n 1
}


function getInfo() {
	link=$1
	#dump=`lynx -dump $link | sed 's/\[..\]//g'` >/dev/null
	dump=`w3m -dump $link` >/dev/null
	both=`echo "$dump" |
        	grep "t like" -B2 |
        	head -n1`
	title=`echo "$dump" |
		grep whyClose -A2 |
		tail -n1`
	info=`echo "$dump" |
		grep 'Published on' -A 100 | 
		grep ' Category' -B 100 | grep ' Category' -v
		#grep BUTTON -B 100 | grep -v BUTTON
		`
	
	likes=`echo $both | cut -d' ' -f1 | sed 's/,//g' `
	dislikes=`echo $both | sed 's/,//g' | awk '{print $2}' `
	#both="$likes|$dislikes"

	#bRate=`echo $(( likes*100 / (likes+dislikes) ))`

	let likes=likes+1
	let dislikes=dislikes+1
	let total=likes+dislikes
	let rate=(likes*100)/total
	#echo Approval $both $rate% "\n" "$dump" #| less
	#printf "Approval %s\n\n%d\n" "$both" "$rate" "$dump" #| less
	#(echo Rating: $rate% $likes\|$dislikes && echo "$dump") | less
	#bar=`
	#printf "$cRed"; for i in {1..10}; do printf "-"; done
	#printf "\r"
	#printf "$cGreen"; for i in $( seq 1 $bl ); do printf "-";done
	#[ 5 -lt $(( rate-bl*10 )) -gt 5 ] && printf "$cYellow-"
	#echo -e $fClear`
	bl=$(( rate/10 ))
	bar=`
	printf "$cGreen"; for i in $( seq 1 $bl ); do printf "-"; done
	[ 5 -le $(( rate-bl*10 )) ] && let bl=bl+1 && printf "$cYellow-"
	printf "$cRed"; for i in $( seq $bl 9 ); do printf "-"; done
	echo -e $fClear`
	(echo -e "$fBright$title$fClear" &&
		printf "Likes $bar " &&
		echo -e $rate% &&
		echo "$info") | less -r
	#echo both = $both
	#echo likes = $likes
	#echo dislikes = $dislikes
	#echo total = likes+dislikes = $((likes+dislikes))
	#echo rate = "(likes*100)/total = " $(( (likes*100)/total ))
	#echo likes $(())

}


function playVideo() {
	title="$1"
	link="$2"
	fileV=$Dir.tmpVid.mp4
	#fileA=$Dir.tmpAud.mp4

	flags=`                                   # medium as default
	 [ $3 ] && (
	  [ $3 == h ] && echo "-xterm256unicode"  # high
          [ $3 == l ] && echo "-fast"             # low
          [ $3 == b ] && echo "-nocolor"          # bad
          [ $3 == B ] && echo "-nocolor -fast"    # like really bad
        )
	`
	
	printf "\n$cBlue Preparing video of$fClear$fBright $title $fClear\n "
	state 0
	getInfo "$link" & >/dev/null
	youtube-dl -qo $fileV $link  -f  18 #160+140 $link
	#youtube-dl -qo $fileA $link  -f  140 & #18 #160+140 $link
	wait
	state 1
	read -p " Press enter to start "

	$player $fileV &
	hiptext $fileV $flags -width 90

	rm $fileA $fileV

}


function createList() {
	touch $Dir$1; N=$1
	printf "${c[b]} Created Playlist $1 ${c[E]}\n"
}


function listLists() {
#	printf "${c[b]} Playlist	Items\n${c[E]}"
#	for i in `ls $Dir | egrep -iv 'websound|local'`; do
#		printf " $i		`grep '|' -c $Dir$i`\n"
#	done; echo

        printf "${c[b]} %-15s %s${c[E]}\n" "Playlist" "Items"
	for i in `ls $Dir | egrep -iv 'websound|local'`; do
		printf " %-18s %2s\n" $i `grep '|' -c $Dir$i`
	done; echo
}


function readList() {
    grep '|' $Dir$N | less
	#cat $Dir$N 2>/dev/null | less
	Head
}


function goToList() {
	new=` ls $Dir | egrep -iv 'websound|local' | grep -iE $1 | head -n 1 `
	[ $new ] && N=$new || printf "$cError No matching playlist $fClear\n"
}


function removeList() {
	printf "${c[b]} Removes playlist $1, with `grep '|' -c $Dir$1` item(s)\n"
	printf "${c[dy]}`cat $Dir$1 | grep '|'` ${c[E]}\n\n"

	read -p "Continue? y/N " c
	if ( echo $c | grep -i "y" ); then
		rm $Dir$1
		if [ "$1" == "$N" ]; then
			N=$n
		fi
	fi
	Head
}



function removeElement() {
    
    hits=`grep -Ei '\|.*'$1 $Dir$N`
    echo "$hits"
    echo
    read -rep "Delete? y/N : " D
    
    if [ "$D" != "y" ]; then return; fi    
    
    if [ $N == "llocal" ]; then
        rm $Local"`ls $Local | grep -Ei $1`"
    fi
    
    tmpList=`grep -v "$(grep -A1 "$hits" $Dir$N | grep -v '|')" $Dir$N`
    echo "$tmpList" | grep -v "$hits" > $Dir$N

    #Head
}



function Help() {
	for i in "${help[@]}"; do
		printf "\033[1m$i${c[E]}\n"
	done | less -r
	Head
}



function Quit() {
    Head "\033[2m${c[ws]}${c[E]}"
    sleep .5
    clear
    exit
}



function main() {
	dbq=`date +%s`  # double quit
	while true; do
	Info

	read -rep "> " U A
	history -s "$U"
	
	# Triple tap exit
	#[ -z $U ] && Head "\033[2;31m${c[ws]}${c[E]}\n" && Info &&
	#read -rep "> " U A &&
	#[ -z $U ] && Head "\033[2m${c[ws]}\n" && Info &&
	#printf "${c[E]}" && read -rep "> " U A && [ -z $U ] && break

	Head
	if [ $U ]; then #Head

		if [ ! $A ]; then
			case $U in
				h)	Help  ;;
                #Q)  Quit  ;;
				#y)	YTsearch  ;;
				#s)	SCsearch ;;
				y|s)	Search $U ;;
				d)	Local ;;
				p)	playAll  ;;
				r)	readList ;;
				l)	listLists  ;;
				e)	$editor $Dir$N  ;;
				*)	playLink "$U" ;;

			esac

		elif [ $A ]; then
			case $A in

				p)	playSpecific "$U";;
				a)	Add "$U"  ;;
				i)  getInfo `getLink "$U"` ;;
				#v)  video `getLink "$U"`  ;;
				k)  removeElement "$U"; Head ;;
				l)  goToList $U  ;;
				L)	createList "$U" ;;
				K)	removeList "$U" ;;
				*)	printf "${C[nProp]}"  ;;

			esac
		fi

	else
		# double quit check
		[ $((`date +%s`-$dbq)) -lt 1 ] && Quit || dbq=`date +%s`
		
		#Head
	fi
	
	done

}

# Start
printf "${C[initial]}"
main





