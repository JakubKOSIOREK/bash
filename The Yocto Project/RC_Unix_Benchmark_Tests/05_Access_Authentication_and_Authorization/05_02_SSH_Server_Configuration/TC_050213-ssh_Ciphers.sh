#!/bin/bash
TEST_TITLE="Ensure only strong Ciphers are used in SSH"
TEST_ID=050213
WEAK_CIPHERS=("3des-cbc" "aes128-cbc" "aes192-cbc" "aes256-cbc" "arcfour" "arcfour128" "arcfour256" "blowfish-cbc" "cast128-cbc" "rijndael-cbc@lysator.liu.se")
SSHD_CONFIG="/etc/sshd_config"

SEARCH_ENTRY="Ciphers"
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
        echo "$TEST_ID:$TEST_TITLE:3:Check test code to set ciphers list"
        exit 3
fi
