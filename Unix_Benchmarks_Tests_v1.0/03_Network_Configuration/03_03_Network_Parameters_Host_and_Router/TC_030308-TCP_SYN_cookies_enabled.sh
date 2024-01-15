#!/bin/bash

TEST_TITLE="Ensure TCP SYN Cookies is enabled"
TEST_ID=030308
EXPECTED_VALUE=1

# Function to check if the setting exists and is set to the expected value
check_setting() {
    local setting=$1
    local value
    local output

    output=$(sysctl "$setting" 2>&1)
    exit_status=$?

    if [ $exit_status -ne 0 ]; then
        if [[ $output == *"No such file or directory"* ]]; then
            echo "$TEST_ID:$TEST_TITLE:2:$setting is not implemented"
            return 2
        else
            echo "$TEST_ID:$TEST_TITLE:1:Error retrieving $setting"
            return 1
        fi
    fi

    value=$(echo "$output" | awk '{print $3}')

    if [ -z "$value" ]; then
        echo "$TEST_ID:$TEST_TITLE:1:$setting has no value"
        return 1
    elif [ "$value" -eq "$EXPECTED_VALUE" ]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:$setting is $value, expected $EXPECTED_VALUE"
        return 1
    fi
}

# Check the setting
check_setting "net.ipv4.tcp_syncookies"
result=$?

# Determine the overall result
if [ "$result" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # If the check returned 'not implemented', return 'not implemented'
    if [ "$result" -eq 2 ]; then
        exit 2
    else
        exit 1
    fi
fi
