#!/bin/bash

TEST_TITLE="Ensure wireless interfaces are disabled"
TEST_ID=030102

# Retrieve the status of wireless interfaces using iwconfig
wifi_status=$(iwconfig 2>&1 | grep -o "no wireless extensions.")

# Check if there are any wireless interfaces implemented
if [ -z "$wifi_status" ]; then
    # iwconfig found wireless extensions, so interfaces are implemented
    interfaces=$(iwconfig 2>&1 | grep '^[a-zA-Z0-9]' | awk '{print $1}')
    all_disabled=true

    for interface in $interfaces
    do
        status=$(iwconfig $interface 2>&1 | grep -o "Power Management:off")

        if [ -z "$status" ]; then
            # This interface is enabled
            echo "$TEST_ID:$TEST_TITLE:1:Interface $interface is enabled"
            all_disabled=false
        fi
    done

    if [ "$all_disabled" = true ]; then
        echo "$TEST_ID:$TEST_TITLE:0"
    else
        exit 1
    fi
else
    echo "$TEST_ID:$TEST_TITLE:2:No wireless interfaces implemented"
    exit 2
fi
