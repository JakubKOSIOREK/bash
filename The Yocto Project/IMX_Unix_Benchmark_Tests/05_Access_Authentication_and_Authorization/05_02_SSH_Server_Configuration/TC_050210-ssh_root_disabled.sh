#!/bin/bash
TEST_TITLE="Ensure SSH root login is disabled"
TEST_ID=050210
SSHD_CONFIG="/etc/ssh/sshd_config"

# Function to check SSH PermitRootLogin setting
check_ssh_permit_root_login() {
    local permit_root_login
    permit_root_login=$(sshd -T | grep -Ei '^\s*permitrootlogin' | awk '{print $2}')

    if [ "$permit_root_login" = "no" ]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Found $permit_root_login"
        return 1
    fi
}

# Check SSH PermitRootLogin setting
if ! check_ssh_permit_root_login; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
