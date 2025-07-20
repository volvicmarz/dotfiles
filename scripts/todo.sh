#!/bin/bash

BLUE='\e[34m' 
RED='\e[31m'
GREEN='\e[32m'
CLEAR='\e[0m'

#colour functions
ColourBlue() {
	echo -ne $BLUE$1$CLEAR
}
ColourRed() {
	echo -ne $RED$1$CLEAR
}
ColourGreen() {
	echo -ne $GREEN$1$CLEAR
}

mapfile tasks < todo.txt
#functions
add() {
	while true; do
	echo -ne $BLUE$"What do you wanna add? "$CLEAR
	read task

	if [[ -n "$task" ]]; then
		tasks=("${tasks[@]}" "$task")
		echo "$task" >> todo.txt
		break
	else
		echo -ne "No input gegeben. Try again "
	fi
done

	show
}
show() {
	cat -n todo.txt
	deleting
}

deleting() {
	echo -ne "Have you already accomplisched anything in the list above?
	$(ColourBlue "yes") 
	$(ColourRed "not yet") 
	"Waiting for the answer: ""
	read answer
	if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
		echo -ne "Which one?"
	elif [[ "$answer" == "no" || "$answer" == "n" ]]; then
		echo -ne "VOOZEFAAAAAAK, Come back later"
	else
		echo -ne $RED"Not expected input"$CLEAR
	fi
}



menu() {
echo -ne "
What do you wanna do now?
$(ColourBlue "1)") Add a new task
$(ColourBlue "2)") See the things I have to do before the end of the world
$(ColourRed "x)") EXIT
"
read input
case $input in
	1) add ; exit 0 ;;
	2) show ; exit 0 ;;
	x) exit 0 ;;
	*) echo -ne $RED"Input is wrong. Try again."$CLEAR ; exit 0 ;; 
esac
}

menu


