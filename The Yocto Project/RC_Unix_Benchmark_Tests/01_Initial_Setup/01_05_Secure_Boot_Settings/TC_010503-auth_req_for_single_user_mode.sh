#!/bin/bash

TEST_TITLE="Ensure authentication required for single user mode"
SHADOW_FILE="/etc/shadow"
TEST_ID=010503

# Check if /etc/shadow file exists
if [ ! -f "$SHADOW_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Shadow file not found"
    exit 2
fi

# Check for root password in /etc/shadow
if grep -q "^root:[*\!]" "$SHADOW_FILE"; then
    echo "$TEST_ID:$TEST_TITLE:1:Root account does not have a password set"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
