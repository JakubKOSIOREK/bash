#!/bin/bash

TEST_TITLE="Ensure TCP SYN Cookies is enabled (Host and Router)"
TEST_ID=030308
EXPECTED_VALUE=1

# Function to check if the setting exist and is set to the expected value
check_setting() {
    local setting=$1
    local output
    local value

    # Attempt to retrive the setting value
    output=$(sysctl "$setting" 2>&1)
    exit_status=$?

    # Check if the setting retrieval resulted in an error
    if [ $exit_status -ne 0 ]; then
        echo "$TEST_ID:$TEST_TITLE:1:Error, type 'sysctl net.ipv4.tcp_syncookies' for more information." # ERROR
        return 1
    fi

    # Extract the value and compare it to the expected value
    if [ "$value" -eq "$EXPECTED_VALUE" ]; then
        echo "$TEST_ID:$TEST_TITLE:0" # PASS
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:$setting is $value, expected $EXPECTED_VALUE" # FAIL
        return 1
    fi
}

# Check the setting
check_setting "net.ipv4.tcp_syncookies"
result=$?

# Determine the overall result based on the check outcome
if [ "$result" -eq 0 ]; then
    exit 0
else
    exit 1
fi