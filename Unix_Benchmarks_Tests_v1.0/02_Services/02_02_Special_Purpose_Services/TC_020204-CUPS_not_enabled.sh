#!/bin/bash

TEST_TITLE="Ensure CUPS is not enabled"
TEST_ID=020204
SERVICE="cups"

# Check if CUPS service is installed
if ! systemctl list-unit-files | grep -q "$SERVICE"; then
    echo "$TEST_ID:$TEST_TITLE:2:CUPS service not found"
    exit 2
fi

# Check if CUPS service is enabled
if systemctl is-enabled --quiet $SERVICE; then
    echo "$TEST_ID:$TEST_TITLE:1:$SERVICE is enabled"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
