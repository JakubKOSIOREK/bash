#!/bin/bash

TEST_TITLE="Ensure core dumps are restricted"
TEST_ID=010604
SYSCTL_PARAM="fs.suid_dumpable"
EXPECTED_VALUE=0

# Check fs.suid_dumpable value
suid_dumpable_value=$(sysctl -n $SYSCTL_PARAM)

# Check for hard core limit in limits.conf
hard_core_set=false
if [ -f "$LIMITS_CONF" ] && grep -qs "^\* hard core $EXPECTED_VALUE$" "$LIMITS_CONF"; then
    hard_core_set=true
fi

# Evaluate conditions
if [ "$suid_dumpable_value" -eq $EXPECTED_VALUE ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:fs.suid_dumpable is set to $suid_dumpable_value, expected $EXPECTED_VALUE"
    exit 1
fi
