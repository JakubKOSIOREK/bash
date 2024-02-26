#!/bin/bash
TEST_TITLE="Ensure SSH PermitUserEnvironment is disabled"
TEST_ID=050212
SSHD_CONFIG="/etc/ssh/sshd_config"

# Function to check SSH PermitUserEnvironment setting
check_ssh_permit_user_environment() {
    local permit_user_environment
    permit_user_environment=$(sshd -T | grep -Ei '^\s*permituserenvironment' | awk '{print $2}')

    if [ "$permit_user_environment" = "no" ]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Found $permit_user_environment"
        return 1
    fi
}

# Check SSH PermitUserEnvironment setting
if ! check_ssh_permit_user_environment; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
