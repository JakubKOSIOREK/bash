#!/bin/bash

TEST_TITLE="Ensure permissions on /etc/crontab are configured"
TEST_ID=050102
CRONTAB_FILE="/etc/crontab"
EXPECTED_PERMISSIONS="600"
EXPECTED_OWNER="0" # UID of root
EXPECTED_GROUP="0" # GID of root

# Check if /etc/crontab file exists
if [[ ! -f $CRONTAB_FILE ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:/etc/crontab file does not exist"
    exit 2
fi

# Check permissions on /etc/crontab
permissions=$(stat -c "%a %u %g" "$CRONTAB_FILE")

# If permissions are not 600 or owner is not root or group is not root, then test fails
if [[ $permissions != "$EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions on $CRONTAB_FILE are not correctly configured. Current $permissions, Expected $EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
