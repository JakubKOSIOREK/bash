#!/bin/bash
TEST_TITLE="Ensure SSH AllowTcpForwarding is disabled"
TEST_ID=050221

# Function to check SSH TCP forwarding configuration
check_ssh_tcp_forwarding() {
    local tcp_forwarding_setting=$(sshd -T | grep -i allowtcpforwarding | awk '{print $2}')

    if [[ "$tcp_forwarding_setting" == "no" ]]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Found '$tcp_forwarding_setting', Expected 'no'."
        return 1
    fi
}

# Check SSH TCP forwarding configuration
if ! check_ssh_tcp_forwarding; then
    exit 1
fi

# If TCP forwarding is correctly configured, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
