#!/bin/bash

TEST_TITLE="Ensure journald is configured to send logs to rsyslog"
TEST_ID=04020201
JOURNALD_CONF="/etc/systemd/journald.conf"

# Function to check if ForwardToSyslog is set to yes
check_forward_to_syslog() {
    if grep -qE '^ForwardToSyslog=yes' "$JOURNALD_CONF"; then
        return 0
    else
        return 1
    fi
}

# Check if journald.conf exists
if [ ! -f "$JOURNALD_CONF" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: journald configuration file not found"
    exit 2
fi

# Check if ForwardToSyslog is correctly configured
if check_forward_to_syslog; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1: ForwardToSyslog is not correctly configured"
    exit 1
fi
