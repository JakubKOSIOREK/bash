#!/bin/bash

TEST_TITLE="Ensure remote login warning banner is configured properly"
TEST_ID=01080103
ISSUE_NET_FILE="/etc/issue.net"

# Check if the ISSUE_NET file exists
if [ ! -f "$ISSUE_NET_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:$ISSUE_NET_FILE does not exist"
    exit 1
fi

# Check for forbidden information in ISSUE_NET
if grep -E -q -i "(\\v|\\r|\\m|\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" "$ISSUE_NET_FILE"; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:$ISSUE_NET_FILE contains forbidden information"
    exit 1
fi
