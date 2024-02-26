#!/bin/bash

TEST_TITLE="Ensure all AppArmor Profiles are in enforce or complain mode"
TEST_ID=01070103
AA_STATUS_CMD="apparmor_status"

# Check if AppArmor is not implemented
if ! command -v aa-status &>/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:2:AppArmor is not installed."
    exit 2
fi

# Check if AppArmor status command exists
if ! command -v $AA_STATUS_CMD &> /dev/null; then
    echo "$TEST_ID:$TEST_TITLE:1:AppArmor status command not found."
    exit 1
fi

# Check for profiles in enforce or complain mode
if $AA_STATUS_CMD | grep -E 'profiles are (in enforce mode|in complain mode)'; then
    if $AA_STATUS_CMD | grep -E 'processes are unconfined'; then
        echo "$TEST_ID:$TEST_TITLE:1:There are unconfined processes."
        exit 1
    else
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    fi
else
    echo "$TEST_ID:$TEST_TITLE:1:Some profiles are not in enforce or complain mode."
    exit 1
fi
