#!/bin/bash

TEST_TITLE="Ensure address space layout randomization (ASLR) is enabled"
TEST_ID=010602
SYSCTL_PARAM="kernel.randomize_va_space"
EXPECTED_VALUE=2

# Check current sysctl setting
current_value=$(sysctl -n $SYSCTL_PARAM)
if [ "$current_value" -ne $EXPECTED_VALUE ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Current setting is $current_value, expected $EXPECTED_VALUE"
    exit 1
fi

# Check if the setting is defined in sysctl configuration files
if grep -qs "$SYSCTL_PARAM.*=.*$EXPECTED_VALUE" /etc/sysctl.conf /etc/sysctl.d/*; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:3:ASLR setting is correct but not defined in configuration files"
    exit 3
fi
