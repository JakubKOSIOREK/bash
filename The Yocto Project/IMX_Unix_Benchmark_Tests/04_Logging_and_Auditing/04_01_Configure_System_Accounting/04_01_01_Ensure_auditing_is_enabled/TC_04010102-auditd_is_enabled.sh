#!/bin/bash

TEST_TITLE="Ensure auditd service is enabled"
TEST_ID=04010102
SERVICE="auditd"

# Function to check if a service is enabled
check_service() {
    local service=$1
    systemctl is-enabled --quiet $service 2>/dev/null
}

# Check if the service is installed
if ! systemctl list-unit-files | grep -q "$SERVICE"; then
    echo "$TEST_ID:$TEST_TITLE:2:$SERVICE service not found"
    exit 2
fi

# Check service status
if check_service $SERVICE; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:$SERVICE is not enabled"
    exit 1
fi
