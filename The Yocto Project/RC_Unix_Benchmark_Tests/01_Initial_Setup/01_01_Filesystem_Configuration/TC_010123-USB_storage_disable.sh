#!/bin/bash

TEST_TITLE="Disable USB Storage"
TEST_ID=010123

# Check if usb-storage module is disabled
module_status=$(modprobe -n -v usb-storage 2>&1)

echo "$module_status" | grep "not found" &>/dev/null
if [[ "$?" -ne 0 ]] || [[ $module_status == "install /bin/true" ]]; then

    # Check if usb-storage module is loaded
    module_loaded=$(lsmod | grep usb-storage)

    # If module is not found or disabled, check if it's loaded
    if [[ -z $module_loaded ]]; then
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:USB Storage module is currently loaded."
        exit 1
    fi
else
    # If module is found and not disabled
    echo "$TEST_ID:$TEST_TITLE:1:USB Storage is not disabled $?."
    exit 1
fi