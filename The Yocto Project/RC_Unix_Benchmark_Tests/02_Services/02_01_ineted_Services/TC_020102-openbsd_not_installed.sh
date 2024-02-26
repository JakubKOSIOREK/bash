#!/bin/bash

PACKAGE="openbsd-inetd"
TEST_ID=020102
TEST_TITLE="Ensure ${PACKAGE} is not installed"

# Initialize status indicators as false
EXECUTABLE_PRESENT=false
SERVICE_ACTIVE=false

# Check for the openbsd-inetd executable
if command -v "$PACKAGE" &>/dev/null;then
    $EXECUTABLE_PRESENT=true
fi

# Check for the service status
if systemctl is-active --quiet "$PACKAGE" &>/dev/null; then
    $SERVICE_ACTIVE=true
fi

# Evaluate results
if $EXECUTABLE_PRESENT || $SERVICE_ACTIVE; then
    echo "$TEST_ID:$TEST_TITLE:1"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi