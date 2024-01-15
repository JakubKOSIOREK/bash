#!/bin/bash

TEST_TITLE="Ensure no legacy '+' entries exist in /etc/passwd"
TEST_ID=060202

# Execute the grep command to check for '+' prefixed accounts
plus_prefixed_accounts=$(grep '^\+:' /etc/passwd)

# Check if any '+' prefixed accounts are found
if [ -z "$plus_prefixed_accounts" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # Format the output to be on one line
    formatted_accounts=$(echo "$plus_prefixed_accounts" | xargs)
    echo "$TEST_ID:$TEST_TITLE:1:Legacy '+' entries found $formatted_accounts"
    exit 1
fi
