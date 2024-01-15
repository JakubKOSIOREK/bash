#!/bin/bash
TEST_TITLE="Ensure SSH LogLevel is appropriate"
TEST_ID=050205
SSHD_CONFIG="/etc/ssh/sshd_config"
ALLOWED_LOGLEVELS=("VERBOSE" "INFO")

# Function to check SSH LogLevel
check_ssh_loglevel() {
    local loglevel
    loglevel=$(sshd -T | grep -Ei '^\s*loglevel' | awk '{print $2}')

    for level in "${ALLOWED_LOGLEVELS[@]}"; do
        if [ "$loglevel" == "$level" ]; then
            return 0
        fi
    done

    echo "$TEST_ID:$TEST_TITLE:1:SSH LogLevel is not set to VERBOSE or INFO. Found $loglevel"
    return 1
}

# Check SSH LogLevel
if ! check_ssh_loglevel; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
