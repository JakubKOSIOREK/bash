#!/bin/bash
TEST_TITLE="Ensure SSH access is limited"
TEST_ID=050218

SSHD_CONFIG="/etc/sshd_config"

SEARCH_ENTRY_1="AllowUsers"
SEARCH_ENTRY_2="AllowGroups"
SEARCH_ENTRY_3="DenyUsers"
SEARCH_ENTRY_4="DenyGroups"

# Check if sshd_config file exists
if [ ! -f "$SSHD_CONFIG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SSHD_CONFIG >> No such file or directory."
    exit 2
fi

entry_1=$(grep "$SEARCH_ENTRY_1" /etc/sshd_config)
entry_2=$(grep "$SEARCH_ENTRY_2" /etc/sshd_config)
entry_3=$(grep "$SEARCH_ENTRY_3" /etc/sshd_config)
entry_4=$(grep "$SEARCH_ENTRY_4" /etc/sshd_config)

if [[ -z "$entry_1" && -z "$entry_2" && -z "$entry_3" && -z "$entry_4" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:No entries found in $SSHD_CONFIG >> $SEARCH_ENTRY_1, $SEARCH_ENTRY_2, $SEARCH_ENTRY_3, $SEARCH_ENTRY_4"
    exit 1
fi


if [[ $entry_1 =~ ^#  && $entry_2 =~ ^# && $entry_3 =~ ^# && $entry_4 =~ ^# ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Entries are commented in $SSHD_CONFIG >> $entry_1 $entry_2 $entry_3 $entry_4"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
