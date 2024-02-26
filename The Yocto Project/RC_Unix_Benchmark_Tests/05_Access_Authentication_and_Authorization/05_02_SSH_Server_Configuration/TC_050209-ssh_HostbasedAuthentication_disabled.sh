#!/bin/bash
TEST_TITLE="Ensure SSH HostbasedAuthentication is disabled"
TEST_ID=050209
SSHD_CONFIG="/etc/sshd_config"

SEARCH_ENTRY="HostbasedAuthentication"
SEARCH_ENTRY_VALUE="no"

# Check if sshd_config file exists
if [ ! -f "$SSHD_CONFIG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SSHD_CONFIG >> No such file or directory."
    exit 2
fi

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

    value=$(echo $entry | awk '{print $2}')

    if [[ $value == $SEARCH_ENTRY_VALUE ]]; then
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:'$SEARCH_ENTRY' entry is not set correctly."
        exit 1
    fi
fi
