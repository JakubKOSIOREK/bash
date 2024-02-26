#!/bin/bash
TEST_TITLE="Ensure SSH PermitEmptyPasswords is disabled"
TEST_ID=050211
SSHD_CONFIG="/etc/ssh/sshd_config"

# Function to check SSH PermitEmptyPasswords setting
check_ssh_permit_empty_passwords() {
    local permit_empty_passwords
    permit_empty_passwords=$(sshd -T | grep -Ei '^\s*permitemptypasswords' | awk '{print $2}')

    if [ "$permit_empty_passwords" = "no" ]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Found $permit_empty_passwords"
        return 1
    fi
}

# Check SSH PermitEmptyPasswords setting
if ! check_ssh_permit_empty_passwords; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
