#!/bin/bash
TEST_TITLE="Ensure SSH PAM is enabled"
TEST_ID=050220

# Function to check SSH PAM configuration
check_ssh_pam() {
    local pam_setting=$(sshd -T | grep -i usepam | awk '{print $2}')

    if [[ "$pam_setting" == "yes" ]]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Found '$pam_setting', Expected 'yes'."
        return 1
    fi
}

# Check SSH PAM configuration
if ! check_ssh_pam; then
    exit 1
fi

# If PAM is correctly configured, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
