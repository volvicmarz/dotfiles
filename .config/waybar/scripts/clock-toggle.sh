#!/bin/bash

File='/tmp/waybar_clock'

if [[ -f $File ]] ; then
    echo "{ \"text\": \"$(date '+%H:%M')\"}"
else
    echo "{ \"text\": \"??:??\"}"
fi
