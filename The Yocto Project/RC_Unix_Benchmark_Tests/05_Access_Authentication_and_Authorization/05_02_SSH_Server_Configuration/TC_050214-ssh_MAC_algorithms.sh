#!/bin/bash
TEST_TITLE="Ensure only strong MAC algorithms are used in SSH"
TEST_ID=050214
SSHD_CONFIG="/etc/sshd_config"
WEAK_MAC_ALGORITHMS=("hmac-md5" "hmac-md5-96" "hmac-ripemd160" "hmac-sha1" "hmac-sha1-96" "umac-64@openssh.com" "umac-128@openssh.com" "hmac-md5-etm@openssh.com" "hmac-md5-96-etm@openssh.com" "hmac-ripemd160-etm@openssh.com" "hmac-sha1-etm@openssh.com" "hmac-sha1-96-etm@openssh.com" "umac-64-etm@openssh.com" "umac-128-etm@openssh.com")

SEARCH_ENTRY="MACs"

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
        echo "$TEST_ID:$TEST_TITLE:3:Check test code to set MACs list"
        exit 3
fi
