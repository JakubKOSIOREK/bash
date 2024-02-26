#!/bin/bash
TEST_TITLE="Ensure SSH Idle Timeout Interval is configured"
TEST_ID=050216
SSHD_CONFIG="/etc/sshd_config"

SEARCH_ENTRY_1="ClientAliveInterval"
SEARCH_ENTRY_1_MAX_VALUE=300
SEARCH_ENTRY_1_MIN_VALUE=1

SEARCH_ENTRY_2="ClientAliveCountMax"
SEARCH_ENTRY_2_MAX_VALUE=3

# Check if sshd_config file exists
if [ ! -f "$SSHD_CONFIG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SSHD_CONFIG >> No such file or directory."
    exit 2
fi

entry_1=$(grep "$SEARCH_ENTRY_1" /etc/sshd_config)
entry_2=$(grep "$SEARCH_ENTRY_2" /etc/sshd_config)

# Check if entry exist
if [[ -z "$entry_1" || -z "$entry_2" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:'$SEARCH_ENTRY_1' entry or '$SEARCH_ENTRY_2' entry not found in $SSHD_CONFIG."
    exit 1
fi

if [[ $entry_1 =~ ^# || $entry_2 =~ ^# ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:'$SEARCH_ENTRY_1' entry or '$SEARCH_ENTRY_2' entry is commented in $SSHD_CONFIG."
    exit 1
else

    value_1=$(echo $entry_1 | awk '{print $2}')
    value_2=$(echo $entry_2 | awk '{print $2}')

    if [[ $value_1 -le $SEARCH_ENTRY_1_MAX_VALUE && $value_1 -ge $SEARCH_ENTRY_1_MIN_VALUE ]]; then
        
        if [[ $value_2 -le $SEARCH_ENTRY_2_MAX_VALUE ]]; then
            echo "$TEST_ID:$TEST_TITLE:0"
            exit 0
        else
            echo "$TEST_ID:$TEST_TITLE:1:'$SEARCH_ENTRY_2' is $value_2 expected $SEARCH_ENTRY_2_MAX_VALUE"
            exit 1
        fi

    else
        echo "$TEST_ID:$TEST_TITLE:1:'$SEARCH_ENTRY_1' is $value_1 expected [ $SEARCH_ENTRY_1_MAX_VALUE - $SEARCH_ENTRY_1_MIN_VALUE ]"
        exit 1
    fi
fi
