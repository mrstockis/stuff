#!/bin/bash
#############################################################
clear				##Clear terminal at start
N="inst"			##Default playlist at start
n=$N
Dir=~/.webSound/	##Location of webSound.sh
Local=$Dir"local/"
Nhits=20			##Number of hits from youtube search
editor="vim"
player="mpv --vid=no --really-quiet" #"--load-unsafe-playlists"	##LUP-flag fixes mpv refusing playback of playlist
#player="omxplayer -o local --vol -900"
#############################################################


# \033[ brightness ; colortext ; colorbackground m :: (0,1,2) ; 30+(0→9) ; 40+(0→9)
# \033[1;32;44m  :: bright green text, on blue background
# \033[0m        :: return to white text on transparent background

declare -A c
	c[B]="\033[1m"; c[D]="\033[2m"; c[E]="\033[0m"
	c[y]="\033[33m"; c[r]="\033[31m";
	c[g]="\033[32m"; c[b]="\033[34m"
	c[Er]="\033[1;39;41m"
	c[ws]=" w e b s o u n d"; c[lo]=" l o c a l"
	c[yt]=" y o u t u b e"; c[sc]=" s o u n d c l o u d"
	c[bad]=" No proper command. Enter 'h' for help"
	c[dot]="---------------------------"

declare -A C
	C[initial]="${c[B]}${c[b]}${c[ws]}${c[E]}\n\n"
	C[default]="${c[b]}${c[ws]}${c[E]}\n\n"
	C[youtube]="${c[B]}${c[r]}${c[yt]}${c[E]}\n\n"
	C[soundcloud]="${c[y]}${c[sc]}${c[E]}\n\n"
	C[Local]="${c[g]}${c[lo]}${c[E]}\n"
	C[saving]="${c[b]}Saving${c[E]}"
	C[to]="${c[b]}to${c[E]}"
	C[state0]="${C[B]}${c[y]}state${c[E]}"
	C[state1]="\b\b\b\b\b${c[g]}state${c[E]}\n"
	C[nProp]="${c[Er]}${c[bad]}${c[E]}\n\n"

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


function Add() {
	#E=`printf "$(youtube-dl --flat-playlist -e "$1")\n" | head -n 1`

	#if [ ! "$E" ]; then E="Playlist?"; fi

	#printf "\n|$E\n"$1"\n" >> $Dir$N
	#printf " ${c[b]}Added:${c[E]}  $E\n    ${c[b]}To:${c[E]}  $N\n"
	
	printf "\n|$1\n$2\n" >> $Dir$N
	printf " ${c[b]}Added:${c[E]}  $1\n    ${c[b]}To:${c[E]}  $N\n"
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
}


function state() {
	if [ $1 == 0 ]; then
		state="${C[state0]}"
	else
		state="${C[state1]}"
	fi
	printf $state
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
	head -n "$Nhits"`

echo
echo "$hits" | cut -d ' ' -f2- | grep -nE '.'
echo

declare -A refs; c=1
for r in `echo "$hits" | cut -d ' ' -f1`; do
	refs[$c]=$r
	((c++))
done

while true; do #PickLoop
read -rep " n a|d: " U A
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

[ -z "$A" ] && echo $title && $player $link ||
([ "$A" == "a" ] && Add "$title" "$link") ||
([ "$A" == "d" ] && Download "$title" "$link") ||
printf " [Number]	→ play choice\n [Number] (a|d)	→ add/download choice\n [empty]	→ back to search\n"

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


function createList() {
	touch $Dir$1; N=$1
	printf "${c[b]} Created Playlist $1 ${c[E]}\n"
}


function listLists() {
	printf "${c[b]} Playlist	Items\n${c[E]}"
	for i in `ls $Dir | egrep -iv 'websound|local'`; do
		printf " $i		`grep '|' -c $Dir$i`\n"
	done; echo
}


function readList() {
    grep '|' $Dir$N | less
	#cat $Dir$N 2>/dev/null | less
	Head
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

	if [ $U ]; then Head

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
				k)  removeElement "$U"; Head ;;
                l)	N=$U  ;;
				L)	createList "$U" ;;
				K)	removeList "$U" ;;
				*)	printf "${C[nProp]}"  ;;

			esac
		fi

	else
		# double quit check
		[ $((`date +%s`-$dbq)) -lt 1 ] && Quit || dbq=`date +%s`
		
		Head
	fi
	
	done

}

# Start
printf "${C[initial]}"
main





