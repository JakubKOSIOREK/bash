#!/bin/bash
TEST_TITLE="Ensure SSH warning banner is configured"
TEST_ID=050219
SSHD_CONFIG="/etc/sshd_config"

SEARCH_ENTRY="Banner"
BANNER_FILE="/etc/issue.net"

# Check if sshd_config file exists
if [ ! -f "$SSHD_CONFIG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SSHD_CONFIG >> No such file or directory."
    exit 2
fi

entry=$(grep "$SEARCH_ENTRY" /etc/sshd_config)

# Check if entry exist
if [ -z "$entry" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:No '$SEARCH_ENTRY' entry found in $SSHD_CONFIG."
    exit 1
fi

if [[ $entry =~ ^# ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:'$SEARCH_ENTRY' entry is commented in $SSHD_CONFIG."
    exit 1
else

    if [ ! -f "$BANNER_FILE" ]; then
        echo "$TEST_ID:$TEST_TITLE:2:Banner $BANNER_FILE >> No such file or directory."
        exit 2
    fi

    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi





