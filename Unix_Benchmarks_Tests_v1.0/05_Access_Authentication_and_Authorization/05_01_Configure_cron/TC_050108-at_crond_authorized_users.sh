#!/bin/bash
TEST_TITLE="Ensure at/cron is restricted to authorized users"
TEST_ID=050108

# Function to check file permissions and ownership
check_permissions_and_ownership() {
    local file=$1
    local expected_permissions="640"
    local expected_uid=0  # UID of root
    local expected_gid=0  # GID of root

    if [[ -f "$file" ]]; then
        local permissions uid gid
        permissions=$(stat -c "%a" "$file")
        uid=$(stat -c "%u" "$file")
        gid=$(stat -c "%g" "$file")

        if [[ "$permissions" != "$expected_permissions" || "$uid" -ne "$expected_uid" || "$gid" -ne "$expected_gid" ]]; then
            echo "$TEST_ID:$TEST_TITLE:1:Incorrect permissions or ownership on $file. Found Permissions: $permissions, Owner: $uid, Group: $gid."
            return 1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:1:$file does not exist"
        return 1
    fi
    return 0
}

# Check if /etc/cron.deny and /etc/at.deny do not exist
if [[ -f /etc/cron.deny || -f /etc/at.deny ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:/etc/cron.deny or /etc/at.deny file exists"
    exit 1
fi

# Check permissions and ownership of /etc/cron.allow
if ! check_permissions_and_ownership "/etc/cron.allow"; then
    exit 1
fi

# Check if the 'at' package is installed and permissions on /etc/at.allow
if dpkg -s at &> /dev/null; then
    if ! check_permissions_and_ownership "/etc/at.allow"; then
        exit 1
    fi
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
