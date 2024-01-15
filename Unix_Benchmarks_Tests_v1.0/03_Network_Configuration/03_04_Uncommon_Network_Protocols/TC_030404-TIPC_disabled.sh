#!/bin/bash

TEST_TITLE="Ensure TIPC is disabled"
TEST_ID=030404

# Function to check if TIPC is disabled
check_tipc() {
    local modprobe_output
    local lsmod_output
    local modprobe_exit_status

    modprobe_output=$(modprobe -n -v tipc 2>&1)
    modprobe_exit_status=$?
    lsmod_output=$(lsmod | grep tipc)

    # Check if modprobe command failed indicating the module is not implemented
    if [ $modprobe_exit_status -ne 0 ]; then
        if [[ $modprobe_output == *"not found"* ]]; then
            echo "$TEST_ID:$TEST_TITLE:2:TIPC module is not implemented"
            return 2
        else
            echo "$TEST_ID:$TEST_TITLE:1:Error checking TIPC module status"
            return 1
        fi
    fi

    # Check if modprobe output indicates 'install /bin/true' which means TIPC is disabled
    if [[ $modprobe_output == *"install /bin/true"* ]]; then
        if [[ -z $lsmod_output ]]; then
            echo "$TEST_ID:$TEST_TITLE:0"
            return 0 # TIPC is disabled
        else
            echo "$TEST_ID:$TEST_TITLE:1:TIPC module is disabled but currently loaded"
            return 1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:1:TIPC module is not disabled"
        return 1
    fi
}

# Check if TIPC is disabled
check_tipc
result=$?

exit $result
