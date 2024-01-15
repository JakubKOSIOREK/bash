#!/bin/bash

TEST_TITLE="Disable USB Storage"
TEST_ID=010123

# Check if usb-storage module is disabled
module_status=$(modprobe -n -v usb-storage 2>&1)

# If module is not disabled, then test fails
if [[ $module_status != "install /bin/true" ]]
then
    echo "$TEST_ID:$TEST_TITLE:1:USB Storage is not disabled"
    exit 1
fi

# Check if usb-storage module is loaded
module_loaded=$(lsmod | grep usb-storage)

# If module is loaded, then test fails
if [[ ! -z $module_loaded ]]
then
    echo "$TEST_ID:$TEST_TITLE:1:USB Storage module is loaded"
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
