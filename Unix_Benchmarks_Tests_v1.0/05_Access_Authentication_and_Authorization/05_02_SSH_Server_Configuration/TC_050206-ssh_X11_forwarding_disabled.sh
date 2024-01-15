#!/bin/bash
TEST_TITLE="Ensure SSH X11 forwarding is disabled"
TEST_ID=050206
SSHD_CONFIG="/etc/ssh/sshd_config"
EXPECTED_SETTING="no"

# Function to check SSH X11 forwarding
check_ssh_x11_forwarding() {
    local x11_forwarding
    x11_forwarding=$(sshd -T | grep -Ei '^\s*x11forwarding' | awk '{print $2}')

    if [ "$x11_forwarding" != "$EXPECTED_SETTING" ]; then
        echo "$TEST_ID:$TEST_TITLE:1:SSH X11 forwarding is not disabled. Found $x11_forwarding, Expected $EXPECTED_SETTING"
        return 1
    fi
    return 0
}

# Check SSH X11 forwarding
if ! check_ssh_x11_forwarding; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
