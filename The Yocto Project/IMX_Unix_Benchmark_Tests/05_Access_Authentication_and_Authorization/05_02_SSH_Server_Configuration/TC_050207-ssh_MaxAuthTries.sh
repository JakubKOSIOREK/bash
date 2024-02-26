#!/bin/bash
TEST_TITLE="Ensure SSH MaxAuthTries is set to 4 or less"
TEST_ID=050207
SSHD_CONFIG="/etc/ssh/sshd_config"
MAX_TRIES=4

# Function to check SSH MaxAuthTries setting
check_ssh_max_auth_tries() {
    local max_auth_tries
    max_auth_tries=$(sshd -T | grep -Ei '^\s*maxauthtries' | awk '{print $2}')

    if [ "$max_auth_tries" -le "$MAX_TRIES" ]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:SSH MaxAuthTries is greater than $MAX_TRIES. Found $max_auth_tries"
        return 1
    fi
}

# Check SSH MaxAuthTries setting
if ! check_ssh_max_auth_tries; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
