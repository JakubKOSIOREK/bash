#!/bin/bash

TEST_TITLE="Ensure message of the day is configured properly"
TEST_ID=01080101
MOTD_FILE="/etc/motd"

# Check if the MOTD file exists
if [ ! -f "$MOTD_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:$MOTD_FILE does not exist"
    exit 1
fi

# Check for forbidden information in MOTD
if grep -E -i "(\\v|\\r|\\m|\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" "$MOTD_FILE"; then
    echo "$TEST_ID:$TEST_TITLE:1:$MOTD_FILE contains forbidden information"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
