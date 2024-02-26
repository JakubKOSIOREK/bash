#!/bin/bash

TEST_TITLE="Ensure wireless interfaces are disabled"
TEST_ID=030102

# define known wired and local interfaces
KNOWN_INTERFACES="lo eth sgred"

# List of patterns that might indicate a wireless interfaces
WIRELESS_INTERFACES=("wlan")  

# Retrive a list of all network interfaces excluding lo, eth* and sgred
interfaces=$(ip link show | awk -F': ' '{print $2}' | awk '{print $1}' | egrep -v "^(${KNOWN_INTERFACES})$")

# Initialize a flag indicating that no wireless interfaces are found
no_wireless=true

# Check each interfaces to determine if it's wireless
for interface in $interfaces; do
    for pattern in "${WIRELESS_INTERFACES[@]}"; do
        if [[ $interface =~ $pattern ]]; then
            echo "$TEST_ID:$TEST_TITLE:1: Interface $interface is present."
            no_wireless=false
            break 2 # Exit both loops on first found wireless interface
        fi
    done
done

# Final evaluation
if $no_wireless; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # Exit with an error status if a wireless interface was found
    exit 1
fi
