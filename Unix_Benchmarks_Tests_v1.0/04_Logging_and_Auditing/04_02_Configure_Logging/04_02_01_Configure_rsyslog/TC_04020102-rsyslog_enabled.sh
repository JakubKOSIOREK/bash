#!/bin/bash

TEST_TITLE="Ensure rsyslog Service is enabled"
TEST_ID=04020102

# Function to check if rsyslog service is enabled
check_rsyslog_enabled() {
    systemctl is-enabled syslog &> /dev/null
}

# Check if rsyslog service is enabled
if check_rsyslog_enabled; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:${RSYSLOG} service is not enabled"
    exit 1
fi
