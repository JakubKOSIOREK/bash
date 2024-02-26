#!/bin/bash

TEST_TITLE="Ensure CUPS is not enabled"
TEST_ID=020204
PACKAGE="cups"

# Initialize status indicators as false
EXECUTABLE_PRESENT=false
SERVICE_ACTIVE=false

# Check for the cups executable
if command -v "$PACKAGE" &>/dev/null;then
    $EXECUTABLE_PRESENT=true
fi

# Check for the cups service status
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
