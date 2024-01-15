#!/bin/bash

TEST_TITLE="Ensure root is the only UID 0 account"
TEST_ID=060206

# Check for any UID 0 accounts other than root
uid_0_accounts=$(awk -F: '($3 == 0) {print $1}' /etc/passwd)

# Check if root is the only UID 0 account
if [[ $uid_0_accounts == "root" ]]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    non_root_accounts=$(echo "$uid_0_accounts" | grep -v "^root$")
    echo "$TEST_ID:$TEST_TITLE:1:Other UID 0 accounts found $non_root_accounts"
    exit 1
fi
