#!/bin/bash
TEST_TITLE="Ensure password expiration warning days is 7 or more"
TEST_ID=05040103

LOGIN_DEFS_FILE="/etc/login.defs"

# Check if sshd_config file exists
if [ ! -f "$LOGIN_DEFS_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$LOGIN_DEFS_FILE >> No such file or directory."
    exit 2
fi
