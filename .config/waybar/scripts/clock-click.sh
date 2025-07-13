#!/bin/bash
File='/tmp/waybar_clock'

if [[ -f $File ]] ; then
    rm $File
else
    notify-send "Detective..." "Have you lost your watch along with your badge?"
    touch $File
fi
