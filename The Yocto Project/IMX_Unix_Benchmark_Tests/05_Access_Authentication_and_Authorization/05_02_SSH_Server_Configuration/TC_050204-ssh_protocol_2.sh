#!/bin/bash
TEST_TITLE="Ensure SSH Protocol is set to 2"
TEST_ID=050204
SSHD_CONFIG="/etc/ssh/sshd_config"
EXPECTED_PROTOCOL=2

# Function to check SSH protocol version
check_ssh_protocol() {
    local protocol
    protocol=$(sshd -T | grep -Ei '^\s*protocol' | awk '{print $2}')

    # If no protocol is found, assume Protocol 2 is being used
    if [ -z "$protocol" ]; then
        echo "$TEST_ID:$TEST_TITLE:3:No Protocol parameter in $SSHD_CONFIG, assume Protocol 2 is being used"
        protocol=$EXPECTED_PROTOCOL
    fi

    if [ "$protocol" != "$EXPECTED_PROTOCOL" ]; then
        echo "$TEST_ID:$TEST_TITLE:1:SSH protocol is not correctly set. Found $protocol, Expected $EXPECTED_PROTOCOL."
        return 1
    fi
    return 0
}

# Check SSH protocol version
if ! check_ssh_protocol; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
