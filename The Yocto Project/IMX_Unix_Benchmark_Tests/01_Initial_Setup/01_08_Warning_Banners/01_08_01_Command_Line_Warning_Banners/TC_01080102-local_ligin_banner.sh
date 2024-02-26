#!/bin/bash

TEST_TITLE="Ensure local login warning banner is configured properly"
TEST_ID=01080102
ISSUE_FILE="/etc/issue"

# Check if the ISSUE file exists
if [ ! -f "$ISSUE_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:$ISSUE_FILE does not exist."
    exit 1
fi

# Check for forbidden information in ISSUE
if grep -E -q -i "(\\v|\\r|\\m|\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" "$ISSUE_FILE"; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:$ISSUE_FILE contains forbidden information."
    exit 1
fi
