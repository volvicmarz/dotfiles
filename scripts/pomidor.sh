#!/bin/bash

#qayit- yaxsilasdir
menu() {
echo -n "Now is the time to let yourself finally cook!
How many minutes should your today's session be?"
while true; do
	read minutes
	if  [[ ${minutes} -gt 0 ]] && [[ ${minutes} -lt 125 ]]; then
		echo "Your timer of ${minutes} minutes starts now" #qayit
		seconds=$((minutes * 60 ))
		break
	else
		echo -n "Wrong input. Write again"
	fi
done
}

if [[ $# -eq  0 ]]; then
	menu
else
	while getopts ":h:m:" opt ; do
		case $opt in 
			h)
				hours=${OPTARG}
				if [[ ${hours} -gt 0 ]] && [[ ${hours} -lt 3 ]]; then
					echo -n "What about minutes? "
					read hmins
					echo -n "Your timer is set to ${hours} hour(s) and ${hmins} minutes"
					seconds=$((hours * 3600 + hmins * 60 ))
				else
					echo -n "How many hours do you plan on studying?"
					exit 1
				fi
				;;
			m)
				mins=${OPTARG}
				if  [[ ${mins} -gt 0 ]] && [[ ${mins} -lt 125 ]]; then
				echo -n "Your timer is set to ${mins} minutes" #qayit
				seconds=$((mins * 60 ))
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
fi

#interactive timer

trap "echo You left ; exit" SIGINT
bar_width=30
time=${seconds}
while [[ ${seconds} -ge 0 ]]; do
	timer1=$((seconds / 60))
	timer2=$((seconds % 60))
	#printf "\r⏳Remaining: %02d:%02d" ${timer1} ${timer2}
	sleep 1
	seconds=$(( seconds - 1 ))
	#progress bar
	filled=$((seconds * bar_width / time))
	empty=$((bar_width - filled))
	bar=$(printf '=%.0s' $(seq 1 $filled))
	space=$(printf ' %.0s' $(seq 1 $empty))
	printf "\r[%-s%s] ⏳Remaining: %02d:%02d" "$bar" "$space" "$timer1" "$timer2" 

done



