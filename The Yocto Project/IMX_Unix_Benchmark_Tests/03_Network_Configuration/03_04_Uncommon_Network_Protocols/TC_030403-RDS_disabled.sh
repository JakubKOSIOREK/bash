#!/bin/bash

TEST_TITLE="Ensure RDS is disabled"
TEST_ID=030403

# Function to check if RDS is disabled
check_rds() {
    local modprobe_output
    local lsmod_output
    local modprobe_exit_status

    modprobe_output=$(modprobe -n -v rds 2>&1)
    modprobe_exit_status=$?
    lsmod_output=$(lsmod | grep rds)

    if [ $modprobe_exit_status -ne 0 ]; then
        if [[ $modprobe_output == *"not found"* ]]; then
            
            #echo "$TEST_ID:$TEST_TITLE:2:RDS module is not implemented"
            #return 2

            echo "$TEST_ID:$TEST_TITLE:0" # PASS
            return 0 # RDS is disabled            
        else
            echo "$TEST_ID:$TEST_TITLE:1:Error checking RDS module status"
            return 1
        fi
    fi

    if [[ $modprobe_output == *"install /bin/true"* ]]; then
        if [[ -z $lsmod_output ]]; then
            echo "$TEST_ID:$TEST_TITLE:0"
            return 0 # RDS is disabled
        else
            echo "$TEST_ID:$TEST_TITLE:1:RDS module is disabled but currently loaded"
            return 1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:1:RDS module is not disabled"
        return 1
    fi
}

# Check if RDS is disabled
check_rds
result=$?

# Determine the overall result
if [ "$result" -eq 0 ]; then
    exit 0
else
    exit 1
fi
