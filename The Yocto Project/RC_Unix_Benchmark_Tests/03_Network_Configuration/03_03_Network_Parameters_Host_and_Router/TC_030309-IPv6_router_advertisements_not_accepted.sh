#!/bin/bash

TEST_TITLE="Ensure IPv6 router advertisements are not accepted"
TEST_ID=030309
EXPECTED_VALUE=0

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

# Check if IPv6 is enabled
ipv6_enabled=$(sysctl net.ipv6.conf.all.disable_ipv6 2> /dev/null | awk '{print $3}')
if [ "$ipv6_enabled" -ne 0 ]; then
    # IPv6 is disabled or not implemented, pass the test
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # Check both IPv6 settings
    check_setting "net.ipv6.conf.all.accept_ra"
    all_result=$?

    check_setting "net.ipv6.conf.default.accept_ra"
    default_result=$?

    # Determine overall result
    if [ "$all_result" -eq 0 ] && [ "$default_result" -eq 0 ]; then
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    else
        # If either check returned 'not implemented', return 'not implemented'
        if [ "$all_result" -eq 2 ] || [ "$default_result" -eq 2 ]; then
            exit 2
        else
            exit 1
        fi
    fi
fi
