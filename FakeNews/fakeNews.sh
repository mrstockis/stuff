#!/bin/bash

# Full or partial site i entered when requested
# Script sifts through reported sites, notorious for false news á 4 categories
# Then prints the findings together with description of associated category
# End with disclosure (may not be fake; this is not enough to tell either; just to endorses sceptisim, where it's due.)

echo "Enter [1-4] to get further information about categories related to a hit. Full list of sites [f]."

while true; do
echo
echo "Check for:"

read TERM
echo

if [ $TERM == '1' ]; then
	echo "Sensationalism: May rely on “outrage” by using distorted headlines and decontextualized or dubious information in order to generate likes, shares, and profits."
elif [ $TERM == '2' ]; then
	echo "Misleading/Desinformation: May circulate misleading and/or potentially unreliable information."
elif [ $TERM == '3' ]; then
	echo "Clickbait: May use clickbait-y headlines and social media descriptions."
elif [ $TERM == '4' ]; then
	echo "Satire: Other sources on this list are purposefully fake with the intent of satire/comedy, which can offer important critical commentary on politics and society, but have the potential to be shared as actual/literal news."
elif [ $TERM == 'f' ]; then
	cat ~/SCRIPT/FakeNews/FakeList
else
	HIT=$(cat ~/SCRIPT/FakeNews/FakeList | grep -i $TERM)
echo $HIT
fi

echo
echo --


done
