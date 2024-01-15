#!/bin/bash
TEST_TITLE="Ensure SSH IgnoreRhosts is enabled"
TEST_ID=050208
SSHD_CONFIG="/etc/ssh/sshd_config"

# Function to check SSH IgnoreRhosts setting
check_ssh_ignore_rhosts() {
    local ignore_rhosts
    ignore_rhosts=$(sshd -T | grep -Ei '^\s*ignorerhosts' | awk '{print $2}')

    if [ "$ignore_rhosts" = "yes" ]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:SSH IgnoreRhosts is not enabled. Found $ignore_rhosts"
        return 1
    fi
}

# Check SSH IgnoreRhosts setting
if ! check_ssh_ignore_rhosts; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
