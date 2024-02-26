#!/bin/bash
TEST_TITLE="Ensure SSH MaxSessions is limited"
TEST_ID=050223

# Function to check SSH MaxSessions configuration
check_ssh_max_sessions() {
    local max_sessions_setting=$(sshd -T | grep -i maxsessions | awk '{print $2}')

    if [[ "$max_sessions_setting" -le 10 ]]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Found '${max_sessions_setting}', should be 10 or less."
        return 1
    fi
}

# Check SSH MaxSessions configuration
if ! check_ssh_max_sessions; then
    exit 1
fi

# If MaxSessions is correctly configured, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
