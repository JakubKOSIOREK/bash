#!/bin/bash

TEST_TITLE="Ensure SCTP is disabled"
TEST_ID=030402

# Function to check if SCTP is disabled
check_sctp() {
    local modprobe_output
    local lsmod_output
    local modprobe_exit_status

    modprobe_output=$(modprobe -n -v sctp 2>&1)
    modprobe_exit_status=$?
    lsmod_output=$(lsmod | grep sctp)

    # Check if modprobe command failed indicating the module is not implemented
    if [ $modprobe_exit_status -ne 0 ]; then
        if [[ $modprobe_output == *"not found"* ]]; then
            
            #echo "$TEST_ID:$TEST_TITLE:2:SCTP module is not implemented"
            #return 2
            
            echo "$TEST_ID:$TEST_TITLE:0" # PASS
            return 0 # SCTP is disabled
        else
            echo "$TEST_ID:$TEST_TITLE:1:Error checking SCTP module status"
            return 1
        fi
    fi

    # Check if modprobe output indicates 'install /bin/true' which means SCTP is disabled
    if [[ $modprobe_output == *"install /bin/true"* ]]; then
        if [[ -z $lsmod_output ]]; then
            echo "$TEST_ID:$TEST_TITLE:0"
            return 0 # SCTP is disabled
        else
            echo "$TEST_ID:$TEST_TITLE:1:SCTP module is disabled but currently loaded"
            return 1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:1:SCTP module is not disabled"
        return 1
    fi
}

# Check if SCTP is disabled
check_sctp
result=$?

# Determine the overall result
if [ "$result" -eq 0 ]; then
    exit 0
else
    exit 1
fi
