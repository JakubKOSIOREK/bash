#!/bin/bash
TEST_TITLE="Ensure permissions on SSH private host key files are configured"
TEST_ID=050202
SSH_DIR="/etc/ssh"
EXPECTED_PERMISSIONS="600"
EXPECTED_OWNER=0  # UID of root
EXPECTED_GROUP=0  # GID of root

# Function to check file permissions and ownership
check_file_permissions() {
    local file=$1
    local expected_permissions=$2
    local expected_uid=$3
    local expected_gid=$4

    local permissions uid gid
    permissions=$(stat -c "%a" "$file")
    uid=$(stat -c "%u" "$file")
    gid=$(stat -c "%g" "$file")

    if [[ "$permissions" != "$expected_permissions" || "$uid" -ne "$expected_uid" || "$gid" -ne "$expected_gid" ]]; then
        echo "$TEST_ID:$TEST_TITLE:1:Incorrect permissions or ownership for $file. Current $permissions, Expected $EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP."
        return 1
    fi
    return 0
}

# Check permissions and ownership of each SSH private host key
for key_file in $SSH_DIR/ssh_host_*_key; do
    if [ -f "$key_file" ]; then
        if ! check_file_permissions "$key_file" "$EXPECTED_PERMISSIONS" "$EXPECTED_OWNER" "$EXPECTED_GROUP"; then
            exit 1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:1:SSH private host key file $key_file not found."
        exit 1
    fi
done

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
