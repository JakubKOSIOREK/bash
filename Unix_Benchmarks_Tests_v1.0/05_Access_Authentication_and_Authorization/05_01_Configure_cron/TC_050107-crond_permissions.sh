#!/bin/bash
TEST_TITLE="Ensure permissions on /etc/cron.d are configured"
TEST_ID=050107
CRONS_FILES_DIR="/etc/cron.d"

# Check if /etc/cron.d directory exists
if [[ ! -d /etc/cron.d ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$CRONS_FILES_DIR directory does not exist"
    exit 2
fi

# Check permissions on /etc/cron.d
permissions=$(stat -c "%a %u %g" "$CRONS_FILES_DIR")

# If permissions are not 700 or owner is not root or group is not root, then test fails
if [[ $permissions != "700 0 0" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions on $CRONS_FILES_DIR are not correctly configured. Current $permissions, Expected 700 0 0."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
