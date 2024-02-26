#!/bin/bash

TEST_TITLE="Ensure no legacy '+' entries exist in /etc/group"
TEST_ID=060205
FILE="/etc/group"

# Check if file exists
if [[ ! -f "$FILE" ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$FILE >> No such file or directory."
    exit 2
fi

# Execute the grep command to check for '+' prefixed accounts
plus_prefixed_entries=$(grep '^\+:' $FILE)

# Check if any '+' prefixed accounts are found
if [ -z "$plus_prefixed_entries" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # Format the output to be on one line
    formatted_entries=$(echo "$plus_prefixed_entries" | xargs)
    echo "$TEST_ID:$TEST_TITLE:1:Legacy '+' entries found $formatted_entries"
    exit 1
fi
