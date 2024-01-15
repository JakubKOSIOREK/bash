#!/bin/bash

TEST_TITLE="Ensure logrotate assigns appropriate permissions"
TEST_ID=0404
LOGROTATE_CONF="/etc/logrotate.conf"

# Function to check permissions in logrotate configuration
check_logrotate_permissions() {
    if grep -E "^\s*create\s+\S+" "$LOGROTATE_CONF" | grep -E -q "\s(0)?[0-6][04]0\s"; then
        return 1
    fi
    return 0
}

# Check if logrotate.conf exists
if [ ! -f "$LOGROTATE_CONF" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: logrotate configuration file not found"
    exit 2
fi

# Check logrotate permissions configuration
if check_logrotate_permissions; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1: logrotate permissions are not configured correctly"
    exit 1
fi
