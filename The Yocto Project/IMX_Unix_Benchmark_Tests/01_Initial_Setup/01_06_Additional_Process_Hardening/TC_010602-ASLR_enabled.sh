#!/bin/bash

TEST_TITLE="Ensure address space layout randomization (ASLR) is enabled"
TEST_ID=010602
SYSCTL_PARAM="kernel.randomize_va_space"
EXPECTED_VALUE=2

# Check current sysctl setting
current_value=$(sysctl -n $SYSCTL_PARAM)
if [ "$current_value" -eq $EXPECTED_VALUE ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Current ASLR setting is $current_value, expected $EXPECTED_VALUE"
    exit 1
fi
