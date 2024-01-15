#!/bin/bash
TEST_TITLE="Ensure SSH HostbasedAuthentication is disabled"
TEST_ID=050209
SSHD_CONFIG="/etc/ssh/sshd_config"

# Function to check SSH HostbasedAuthentication setting
check_ssh_hostbased_authentication() {
    local hostbased_auth
    hostbased_auth=$(sshd -T | grep -Ei '^\s*hostbasedauthentication' | awk '{print $2}')

    if [ "$hostbased_auth" = "no" ]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:SSH HostbasedAuthentication is not disabled. Found $hostbased_auth"
        return 1
    fi
}

# Check SSH HostbasedAuthentication setting
if ! check_ssh_hostbased_authentication; then
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
