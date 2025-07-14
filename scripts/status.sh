#!/bin/bash

#colours (ANSI Color Codes)
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

#colorfunctions
ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -n $blue$1$clear
}

server_name=$(hostname)
function memory_check() {
	echo ""
	echo "The current memory usage on ${server_name} is: "
	free -h
	echo ""
}


function cpu_usage() {
	echo "The current cpu usage is: "
	uptime
	echo ""
}

function kernel_version() {
	echo "The kernel version is: "
	echo ""
	uname -r
	echo ""
}

function all_checks() {
	memory_check
	cpu_usage
	kernel_version 
}
menu(){
echo -ne "
System Status Menu
$(ColorGreen '1)') Memory Usage
$(ColorGreen '2)') Cpu Usage
$(ColorGreen '3)') Kernel Version
$(ColorGreen '4)') Check All
$(ColorGreen 'x)') Exit
$(ColorBlue 'Choose an option:') "
	read a
	case $a in 
		1) memory_check ; exit 0 ;;
		2) cpu_usage ; exit 0 ;;
		3) kernel_version ; exit 0 ;;
		4) all_checks ; exit 0 ;;
		x) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; exit 0 ;;
	esac
}

menu
