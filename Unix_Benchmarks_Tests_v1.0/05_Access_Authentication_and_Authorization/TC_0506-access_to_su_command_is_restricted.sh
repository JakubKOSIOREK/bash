#!/bin/bash
TEST_TITLE="Ensure access to the su command is restricted"
TEST_ID=0506

# Check the /etc/pam.d/su file
PAM_SU_FILE="/etc/pam.d/su"
EXPECTED_PAM_CONFIG="auth required pam_wheel.so use_uid"

# Function to check if pam_wheel.so is configured correctly
check_pam_wheel_configuration() {
    local group_name
    if grep -q "$EXPECTED_PAM_CONFIG" "$PAM_SU_FILE"; then
        group_name=$(grep "$EXPECTED_PAM_CONFIG" "$PAM_SU_FILE" | awk '{print $NF}')
        if [[ -z "$group_name" ]]; then
            echo "$TEST_ID:$TEST_TITLE:1:Group name not specified in $PAM_SU_FILE"
            return 1
        fi
        check_group_empty "$group_name"
    else
        echo "$TEST_ID:$TEST_TITLE:1:$EXPECTED_PAM_CONFIG not found in $PAM_SU_FILE"
        return 1
    fi
}

# Function to check if the group is empty
check_group_empty() {
    local group_name=$1
    if grep -q "^$group_name:" /etc/group && ! grep -q "^$group_name:[^:]*:[^:]*:$" /etc/group; then
        echo "$TEST_ID:$TEST_TITLE:1:Group $group_name is not empty"
        return 1
    fi
    return 0
}

# Perform the checks
if [[ -f "$PAM_SU_FILE" ]]; then
    check_pam_wheel_configuration
    if [[ $? -eq 0 ]]; then
        echo "$TEST_ID:$TEST_TITLE:0:Access to the su command is correctly restricted"
        exit 0
    else
        exit 1
    fi
else
    echo "$TEST_ID:$TEST_TITLE:2:$PAM_SU_FILE file not found"
    exit 2
fi
