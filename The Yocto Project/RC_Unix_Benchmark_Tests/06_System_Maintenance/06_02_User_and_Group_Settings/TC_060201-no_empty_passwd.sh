#!/bin/bash

TEST_TITLE="Ensure password fields are not empty"
TEST_ID=060201

# Execute the awk command to check for accounts without passwords
accounts_without_passwords=$(awk -F: '($2 == "" ) { print $1 }' /etc/shadow)

# Check if any accounts without passwords are found
if [ -z "$accounts_without_passwords" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    # Format the output to be on one line
    formatted_accounts=$(echo "$accounts_without_passwords" | xargs)
    echo "$TEST_ID:$TEST_TITLE:1:Accounts without passwords found -> $formatted_accounts"
    exit 1
fi
