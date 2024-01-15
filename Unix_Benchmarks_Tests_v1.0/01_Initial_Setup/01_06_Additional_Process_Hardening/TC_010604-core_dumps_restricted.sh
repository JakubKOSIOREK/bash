#!/bin/bash

TEST_TITLE="Ensure core dumps are restricted"
TEST_ID=010604
LIMITS_CONF="/etc/security/limits.conf"
SYSCTL_PARAM="fs.suid_dumpable"
EXPECTED_VALUE=0
COREDUMP_SERVICE="coredump.service"

# Check fs.suid_dumpable value
suid_dumpable_value=$(sysctl -n $SYSCTL_PARAM)
systemd_coredump_status=$(systemctl is-enabled $COREDUMP_SERVICE &> /dev/null && echo "enabled" || echo "disabled")

# Check for hard core limit in limits.conf
hard_core_set=false
if [ -f "$LIMITS_CONF" ] && grep -qs "^\* hard core $EXPECTED_VALUE$" "$LIMITS_CONF"; then
    hard_core_set=true
fi

# Evaluate conditions
if [ "$suid_dumpable_value" -eq $EXPECTED_VALUE ] && $hard_core_set && [ "$systemd_coredump_status" = "disabled" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
elif [ "$suid_dumpable_value" -eq $EXPECTED_VALUE ] && ! $hard_core_set; then
    echo "$TEST_ID:$TEST_TITLE:3:fs.suid_dumpable is set but hard core limit not correctly set in $LIMITS_CONF"
    exit 3
else
    echo "$TEST_ID:$TEST_TITLE:1:One or more settings are incorrect"
    exit 1
fi
