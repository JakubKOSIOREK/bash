#!/bin/bash
TEST_TITLE="Ensure SSH access is limited"
TEST_ID=050218

# Function to check SSH access restrictions
check_ssh_access_restriction() {
    local allow_users=$(sshd -T | grep allowusers)
    local allow_groups=$(sshd -T | grep allowgroups)
    local deny_users=$(sshd -T | grep denyusers)
    local deny_groups=$(sshd -T | grep denygroups)

    # Check if any of the access restrictions are configured
    if [[ -n "$allow_users" || -n "$allow_groups" || -n "$deny_users" || -n "$deny_groups" ]]; then
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:SSH access is not limited by AllowUsers, AllowGroups, DenyUsers, or DenyGroups."
        return 1
    fi
}

# Check SSH access restrictions
if ! check_ssh_access_restriction; then
    exit 1
fi

# If access is correctly restricted, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
