#!/bin/bash
TEST_TITLE="Ensure permissions on /etc/cron.monthly are configured"
TEST_ID=050106

# Check if /etc/cron.monthly directory exists
if [[ ! -d /etc/cron.monthly ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:/etc/cron.monthly directory does not exist"
    exit 2
fi

# Check permissions on /etc/cron.monthly
permissions=$(stat -c "%a %u %g" /etc/cron.monthly)

# If permissions are not 700 or owner is not root or group is not root, then test fails
if [[ $permissions != "700 0 0" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions on /etc/cron.monthly are not correctly configured. Current $permissions, Expected 700 0 0."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
