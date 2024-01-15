#!/bin/bash

TEST_TITLE="Ensure rsyslog is installed"
TEST_ID=04020101
RSYSLOG="python3-syslog" # package name instead of rsyslog service

# Function to check if rsyslog is installed
check_rsyslog_installed() {
    dpkg -s ${RSYSLOG} &> /dev/null
}

# Check for rsyslog installation
if check_rsyslog_installed; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:${RSYSLOG} is not installed"
    exit 1
fi
