#!/bin/bash

TEST_TITLE="Ensure permissions on /etc/issue.net are configured"
TEST_ID=01080106
FILE="/etc/issue.net"
EXPECTED_PERMISSIONS="644"
EXPECTED_OWNER="0" # UID of root
EXPECTED_GROUP="0" # GID of root

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:$FILE does not exist"
    exit 1
fi

# Get file permissions, owner, and group
file_permissions=$(stat -c "%a" $FILE)
file_owner=$(stat -c "%u" $FILE)
file_group=$(stat -c "%g" $FILE)

# Check file permissions, owner, and group
if [ "$file_permissions" -eq "$EXPECTED_PERMISSIONS" ] && [ "$file_owner" -eq "$EXPECTED_OWNER" ] && [ "$file_group" -eq "$EXPECTED_GROUP" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Incorrect permissions, owner, or group. Found Permissions: $file_permissions, Owner: $file_owner, Group: $file_group"
    exit 1
fi
