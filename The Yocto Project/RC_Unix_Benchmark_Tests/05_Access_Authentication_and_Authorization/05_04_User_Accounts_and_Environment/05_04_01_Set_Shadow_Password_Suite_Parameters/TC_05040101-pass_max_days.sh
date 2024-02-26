#!/bin/bash
TEST_TITLE="Ensure password expiration is 365 days or less"
TEST_ID=05040101

LOGIN_DEFS_FILE="/etc/login.defs"

# Check if sshd_config file exists
if [ ! -f "$LOGIN_DEFS_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$LOGIN_DEFS_FILE >> No such file or directory."
    exit 2
fi
