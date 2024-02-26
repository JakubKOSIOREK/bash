#!/bin/bash

TEST_TITLE="Disable IPv6"
TEST_ID=030101
EXPECTED_VALUE=1
SETTING="net.ipv6.conf.all.disable_ipv6"

# Check if the setting exists
if sysctl $SETTING &> /dev/null; then
    # If the setting exists, get its value
    value=$(sysctl $SETTING | awk '{ print $3 }')

    # Check if the value matches the expected value
    if [ "$value" == "$EXPECTED_VALUE" ]; then
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Setting $SETTING is $value, expected: $EXPECTED_VALUE"
        exit 1
    fi
else
    # If the setting does not exist, output PASS
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
    
    # If the setting does not exist, output NOT IMPLEMENTED
    #echo "$TEST_ID:$TEST_TITLE:2:Setting $SETTING does not exist"
    #exit 2
fi
