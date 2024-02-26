#!/bin/bash
TEST_TITLE="Ensure only strong Key Exchange algorithms are used in SSH"
TEST_ID=050215
WEAK_KEY_ALGORITHMS=("diffie-hellman-group1-sha1" "diffie-hellman-group14-sha1" "diffie-hellman-group-exchange-sha1")

SSHD_CONFIG="/etc/sshd_config"

SEARCH_ENTRY="KexAlgorithms"

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
        echo "$TEST_ID:$TEST_TITLE:3:Check test code to set KexAlgorithms list"
        exit 3
fi
