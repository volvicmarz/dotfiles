#!/usr/bin/env bash

# This script gathers detailed Wi-Fi and Ethernet connection information.
# It collects information like IP address, MAC address, signal strength, etc.

if ! command -v nmcli &>/dev/null && ! command -v ip &>/dev/null; then
        echo "{\"text\": \"󰤮 No Network\", \"tooltip\": \"Network tools are missing\"}"
        exit 1
fi

# Check if Wi-Fi is enabled
wifi_status=$(nmcli radio wifi)
ethernet_status=$(nmcli device status | grep -E 'ethernet' | grep -w 'connected')

# Check for active Ethernet connection
if [ "$ethernet_status" != "" ]; then
        # Ethernet connected, gather Ethernet information
        ethernet_device=$(echo "$ethernet_status" | awk '{print $1}')
        ip_address=$(nmcli -t -f IP4.ADDRESS device show "$ethernet_device" | cut -d: -f2)
        mac_address=$(nmcli -t -f GENERAL.HWADDR device show "$ethernet_device" | cut -d: -f2)
        tooltip="Ethernet Connected\nIP Address: ${ip_address}\nMAC Address: ${mac_address}"
        icon="" # Ethernet icon

        echo "{\"text\": \"${icon}\", \"tooltip\": \"${tooltip}\"}"
        exit 0
fi

# If Wi-Fi is disabled
if [ "$wifi_status" = "disabled" ]; then
        tooltip="Wi-Fi Disabled"
        icon="󰤮" # Icon for no connection or disabled
        echo "{\"text\": \" ${icon} \", \"tooltip\": \"${tooltip}\"}"
        exit 0
fi

# Check if Wi-Fi is connected
wifi_info=$(nmcli -t -f active,ssid,signal,security dev wifi | grep "^yes")

if [ "$wifi_info" = "" ]; then
        essid="No Connection"
        signal=0
        tooltip="No Connection"
else
        # Default values for Wi-Fi
        ip_address="127.0.0.1"
        security=$(echo "$wifi_info" | awk -F: '{print $4}')
        signal=$(echo "$wifi_info" | awk -F: '{print $3}')
        active_device=$(nmcli -t -f DEVICE,STATE device status | grep -w "connected" | grep -v -E "^(dummy|lo:)" | awk -F: '{print $1}')

        # Get device details for Wi-Fi
        if [ "$active_device" != "" ]; then
                output=$(nmcli -e no -g ip4.address,ip4.gateway,general.hwaddr device show "$active_device")
                ip_address=$(echo "$output" | sed -n '1p')

                # Channel, BSSID and Frequency
                line=$(nmcli -e no -t -f active,bssid,chan,freq device wifi | grep "^yes")
                chan=$(echo "$line" | awk -F':' '{print $8}')
                freq=$(echo "$line" | awk -F':' '{print $9}')
                chan="$chan ($freq)"

                # Get signal strength and bitrate information using iw tool
                if command -v iw &>/dev/null; then
                        iw_output=$(iw dev "$active_device" station dump)
                        rx_bitrate=$(echo "$iw_output" | grep "rx bitrate:" | awk '{print $3 " " $4}')
                        tx_bitrate=$(echo "$iw_output" | grep "tx bitrate:" | awk '{print $3 " " $4}')

                        # Physical Layer Mode
                        if echo "$iw_output" | grep -E -q "rx bitrate:.* VHT"; then
                                phy_mode="802.11ac" # Wi-Fi 5
                        elif echo "$iw_output" | grep -E -q "rx bitrate:.* HT"; then
                                phy_mode="802.11n" # Wi-Fi 4
                        elif echo "$iw_output" | grep -E -q "rx bitrate:.* HE"; then
                                phy_mode="802.11ax" # Wi-Fi 6
                        fi
                fi

                essid=$(echo "$wifi_info" | awk -F: '{print $2}')

                # Tooltip details for Wi-Fi
                tooltip="${essid}\nIP Address: ${ip_address}\nSecurity: ${security}\nChannel: ${chan}\nStrength: ${signal} / 100"
                [ "$rx_bitrate" != "" ] && tooltip+="\nRx Rate: ${rx_bitrate}"
                [ "$tx_bitrate" != "" ] && tooltip+="\nTx Rate: ${tx_bitrate}"
                [ "$phy_mode" != "" ] && tooltip+="\nPHY Mode: ${phy_mode}"
        fi
fi

# Determine Wi-Fi icon based on signal strength
if [ "$signal" -ge 80 ]; then
        icon="󰤨" # Strong signal
elif [ "$signal" -ge 60 ]; then
        icon="󰤥" # Good signal
elif [ "$signal" -ge 40 ]; then
        icon="󰤢" # Weak signal
elif [ "$signal" -ge 20 ]; then
        icon="󰤟" # Very weak signal
else
        icon="󰤮" # No signal
fi

# If no Ethernet connection, show Wi-Fi connection
if [ "$ethernet_status" = "" ]; then
        echo "{\"text\": \"${icon}\", \"tooltip\": \"${tooltip}\"}"
fi
