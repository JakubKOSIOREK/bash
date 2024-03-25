#!/bin/bash

TEST_TITLE="Ensure all AppArmor Profiles are enforcing"
TEST_ID=01070104
AA_STATUS_CMD="apparmor_status"

APPARMOR_D_DIR="/etc/apparmor.d"

# Check for existence of file and directory
if [ ! -d "$APPARMOR_D_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$APPARMOR_D_DIR >> No such file or directory."
    exit 2
fi

# Check if AppArmor status command exists
if ! command -v $AA_STATUS_CMD &> /dev/null; then
    echo "$TEST_ID:$TEST_TITLE:2:AppArmor status command not found"
    exit 2
fi

# Check for profiles in enforce mode and no profiles in complain mode
profiles_status=$($AA_STATUS_CMD)
if echo "$profiles_status" | grep -q 'profiles are in enforce mode' && ! echo "$profiles_status" | grep -q 'profiles are in complain mode'; then
    if echo "$profiles_status" | grep -q 'processes are unconfined'; then
        echo "$TEST_ID:$TEST_TITLE:1:There are unconfined processes"
        exit 1
    else
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    fi
else
    echo "$TEST_ID:$TEST_TITLE:1:Some profiles are not in enforce mode or are in complain mode"
    exit 1
fi