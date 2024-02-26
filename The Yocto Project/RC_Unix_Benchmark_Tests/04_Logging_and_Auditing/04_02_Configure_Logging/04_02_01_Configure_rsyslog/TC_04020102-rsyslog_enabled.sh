#!/bin/bash

TEST_TITLE="Ensure rsyslog Service is enabled"
TEST_ID=04020102
SERVICE="syslogd"

# Function to check if rsyslog service is enabled
check_rsyslog_enabled() {
    ps -ef | grep -v grep | grep syslog > /dev/null
}


# Check if command -v for service is available
if ! command -v $SERVICE >/dev/null 2>&1; then
    echo "$TEST_ID:$TEST_TITLE:2:$SERVICE service not found"
    exit 2
fi

# Check if rsyslog service is enabled
if check_rsyslog_enabled; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:${RSYSLOG} service is not enabled"
    exit 1
fi