#!/bin/bash

TEST_TITLE="Ensure auditd service is enabled"
TEST_ID=04010102
SERVICE="auditd"

# Check if command -v for service is available
if ! command -v $SERVICE >/dev/null 2>&1; then
    echo "$TEST_ID:$TEST_TITLE:2:$SERVICE service not found"
    exit 2
fi

# check if the service process is running
if ps -ef | grep -v grep | grep $SERVICE > /dev/null; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:$SERVICE is not enabled"
    exit 1
fi
