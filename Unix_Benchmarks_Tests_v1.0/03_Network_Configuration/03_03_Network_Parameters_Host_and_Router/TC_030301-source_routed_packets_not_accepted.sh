#!/bin/bash

TEST_TITLE="Ensure source routed packets are not accepted"
TEST_ID=030301
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

# Check IPv4 settings
check_setting "net.ipv4.conf.all.accept_source_route"
all_ipv4_result=$?
check_setting "net.ipv4.conf.default.accept_source_route"
default_ipv4_result=$?

# Check if IPv6 is enabled and, if so, check IPv6 settings
ipv6_enabled=$(sysctl net.ipv6.conf.all.disable_ipv6 2> /dev/null | awk '{print $3}')
if [ "$ipv6_enabled" -eq 0 ]; then
    check_setting "net.ipv6.conf.all.accept_source_route"
    all_ipv6_result=$?
    check_setting "net.ipv6.conf.default.accept_source_route"
    default_ipv6_result=$?
else
    all_ipv6_result=0
    default_ipv6_result=0
fi

# Determine overall result
if [ "$all_ipv4_result" -eq 0 ] && [ "$default_ipv4_result" -eq 0 ] && [ "$all_ipv6_result" -eq 0 ] && [ "$default_ipv6_result" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # If any check returned 'not implemented', return 'not implemented'
    if [ "$all_ipv4_result" -eq 2 ] || [ "$default_ipv4_result" -eq 2 ] || [ "$all_ipv6_result" -eq 2 ] || [ "$default_ipv6_result" -eq 2 ]; then
        exit 2
    else
        exit 1
    fi
fi
