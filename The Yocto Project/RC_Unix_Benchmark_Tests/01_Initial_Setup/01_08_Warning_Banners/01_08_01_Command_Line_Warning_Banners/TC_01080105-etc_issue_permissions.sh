#!/bin/bash

TEST_TITLE="Ensure permissions on /etc/issue are configured"
TEST_ID=01080105
ISSUE_FILE="/etc/issue"
EXPECTED_PERMISSIONS="644"
EXPECTED_OWNER="0" # UID of root
EXPECTED_GROUP="0" # GID of root

# Check if the ISSUE file exists
if [ ! -f "$ISSUE_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$ISSUE_FILE >> No such file or directory."
    exit 2
fi

# Get file permissions, owner, and group
file_permissions=$(stat -c "%a" $ISSUE_FILE)
file_owner=$(stat -c "%u" $ISSUE_FILE)
file_group=$(stat -c "%g" $ISSUE_FILE)

# Check file permissions, owner, and group
if [ "$file_permissions" -eq "$EXPECTED_PERMISSIONS" ] && [ "$file_owner" -eq "$EXPECTED_OWNER" ] && [ "$file_group" -eq "$EXPECTED_GROUP" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Incorrect permissions, owner, or group. Found Permissions: $file_permissions, Owner: $file_owner, Group: $file_group"
    exit 1
fi
