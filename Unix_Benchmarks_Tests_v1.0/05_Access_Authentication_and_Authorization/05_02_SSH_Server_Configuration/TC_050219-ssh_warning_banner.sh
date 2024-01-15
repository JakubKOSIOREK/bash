#!/bin/bash
TEST_TITLE="Ensure SSH warning banner is configured"
TEST_ID=050219
EXPECTED_BANNER="/etc/issue.net"

# Function to check SSH warning banner configuration
check_ssh_banner() {
    local current_banner=$(sshd -T | grep banner | awk '{print $2}')

    if [[ "$current_banner" == "$EXPECTED_BANNER" ]]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:SSH warning banner not correctly configured. Found '$current_banner', Expected '$EXPECTED_BANNER'."
        return 1
    fi
}

# Check SSH banner configuration
if ! check_ssh_banner; then
    exit 1
fi

# If banner is correctly configured, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
