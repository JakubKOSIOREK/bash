#!/bin/bash

TEST_TITLE="Ensure bogus ICMP responses are ignored"
TEST_ID=030306
EXPECTED_VALUE=1

# Function to check if the setting exists and is set to the expected value
check_setting() {
    local setting=$1
    local value

    if value=$(sysctl "$setting" 2> /dev/null | awk '{print $3}'); then
        if [ "$value" -eq "$EXPECTED_VALUE" ]; then
            return 0
        else
            echo "$TEST_ID:$TEST_TITLE:1:$setting is $value, expected $EXPECTED_VALUE"
            return 1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:2:$setting is not implemented"
        return 2
    fi
}

# Check the setting
check_setting "net.ipv4.icmp_ignore_bogus_error_responses"
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
