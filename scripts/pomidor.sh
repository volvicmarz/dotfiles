#!/bin/bash

#qayit- yaxsilasdir

asking_for_time() {
echo -n "Now is the time to let yourself finally cook!
How many minutes should your today's session be?"
while true; do
	read minutes
	if  [[ ${minutes} -gt 0 ]] && [[ ${minutes} -lt 125 ]]; then
		echo -n "Your timer is set to ${minutes} minutes" #qayit
		break
	else
		echo -n "Wrong input. Write again"
	fi
done
}

while getopts ":h:m:" opt ; do
	case $opt in 
		h)
			hours=${OPTARG}
			;;
		m)
			mins=${OPTARG}
			if  [[ ${mins} -gt 0 ]] && [[ ${mins} -lt 125 ]]; then
				echo -n "Your timer is set to ${mins} minutes" #qayit
			else
				echo -n "Wrong input"
				exit 1
			fi

			 
			;;
		\?)
			echo "Invalid option -${OPTARG}"
			;;
		:)
			echo "Option -${OPTARG} needs an argument"
			;;
	esac
done
