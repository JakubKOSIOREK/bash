#!/bin/bash

TEST_TITLE="Ensure packet redirect sending is disabled"
TEST_ID=030201
EXPECTED_VALUE=0

# Function to check if the setting exists and is set to the expected value
check_setting() {
    local setting=$1
    local value

    if value=$(sysctl "$setting" 2> /dev/null | awk '{print $3}'); then
        if [ "$value" -eq "$EXPECTED_VALUE" ]; then
            return 0
        else
            echo "$TEST_ID:$TEST_TITLE:1:$setting is $value, expected: $EXPECTED_VALUE"
            return 1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:2:$setting is not implemented"
        return 2
    fi
}

# Check both settings
check_setting "net.ipv4.conf.all.send_redirects"
all_result=$?

check_setting "net.ipv4.conf.default.send_redirects"
default_result=$?

# Determine overall result
if [ "$all_result" -eq 0 ] && [ "$default_result" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # If either check returned 'not implemented', we return 'not implemented'
    if [ "$all_result" -eq 2 ] || [ "$default_result" -eq 2 ]; then
        exit 2
    else
        exit 1
    fi
fi
