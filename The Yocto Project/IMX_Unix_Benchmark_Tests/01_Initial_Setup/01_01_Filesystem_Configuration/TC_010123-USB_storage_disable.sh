#!/bin/bash

TEST_TITLE="Disable USB Storage"
TEST_ID=010123

# Check if usb-storage module is disabled
module_status=$(modprobe -n -v usb-storage 2>&1)

# Check if usb-storage module is loaded
module_loaded=$(lsmod | grep usb-storage)


# Test passes if modprobe command returns "install /bin/true" OR ir both commands returns no output
if [[ $module_status == "install /bin/true" ]] || ([[ -z $module_status ]] && [[ -z $module_loaded ]])
then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi

# If test conditions are not met, then test fails
if [[ $module_status != "install /bin/true" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:USB Storage is not disabled."
elif [[ ! -z $module_loaded ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:USB Storage module is currently loaded."
else
    echo "$TEST_ID:$TEST_TITLE:1:Unknow error."
fi
