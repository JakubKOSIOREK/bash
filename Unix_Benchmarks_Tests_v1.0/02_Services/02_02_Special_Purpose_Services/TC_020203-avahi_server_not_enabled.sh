#!/bin/bash

TEST_TITLE="Ensure Avahi Server is not enabled"
TEST_ID=020203
SERVICE="avahi-daemon"

# Check if Avahi Server is enabled
if systemctl is-enabled --quiet $SERVICE; then
    echo "$TEST_ID:$TEST_TITLE:1"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
