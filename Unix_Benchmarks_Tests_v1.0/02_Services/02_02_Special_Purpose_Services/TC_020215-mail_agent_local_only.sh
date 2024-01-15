#!/bin/bash

TEST_TITLE="Ensure mail transfer agent is configured for local-only mode"
TEST_ID=020215

# Function to check if a mail transfer agent is configured for local-only mode
check_mta() {
    netstat -an | grep LIST | grep ":25[[:space:]]" | grep -q "127.0.0.1"
}

# Check MTA configuration
if check_mta; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Mail transfer agent is not configured for local-only mode"
fi
