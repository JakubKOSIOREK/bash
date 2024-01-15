#!/bin/bash
TEST_TITLE="Ensure SSH MaxStartups is configured"
TEST_ID=050222

# Function to check SSH MaxStartups configuration
check_ssh_max_startups() {
    local max_startups_setting=$(sshd -T | grep -i maxstartups | awk '{print $2}')

    if [[ "$max_startups_setting" == "10:30:60" ]]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:SSH MaxStartups is not correctly configured. Found '$max_startups_setting', Expected '10:30:60'."
        return 1
    fi
}

# Check SSH MaxStartups configuration
if ! check_ssh_max_startups; then
    exit 1
fi

# If MaxStartups is correctly configured, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
