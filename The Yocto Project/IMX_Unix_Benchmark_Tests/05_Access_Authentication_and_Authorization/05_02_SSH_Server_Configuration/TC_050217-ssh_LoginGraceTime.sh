#!/bin/bash
TEST_TITLE="Ensure SSH LoginGraceTime is set to one minute or less"
TEST_ID=050217
MAX_LOGIN_GRACE_TIME=60 # 60 seconds

# Function to check the SSH LoginGraceTime configuration
check_ssh_login_grace_time() {
    local grace_time
    grace_time=$(sshd -T | grep logingracetime | awk '{print $2}')

    # Check if grace_time is not empty and less than or equal to MAX_LOGIN_GRACE_TIME
    if [[ -n "$grace_time" && "$grace_time" -le "$MAX_LOGIN_GRACE_TIME" ]]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Found $grace_time, Expected $MAX_LOGIN_GRACE_TIME or less."
        return 1
    fi
}

# Check the SSH LoginGraceTime configuration
if ! check_ssh_login_grace_time; then
    exit 1
fi

# If configuration is correct, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
