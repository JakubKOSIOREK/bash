#!/bin/bash
TEST_TITLE="Ensure permissions on /etc/cron.daily are configured"
TEST_ID=050104

# Check if /etc/cron.daily directory exists
if [[ ! -d /etc/cron.daily ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:/etc/cron.daily directory does not exist"
    exit 2
fi

# Check permissions on /etc/cron.daily
permissions=$(stat -c "%a %u %g" /etc/cron.daily)

# If permissions are not 700 or owner is not root or group is not root, then test fails
if [[ $permissions != "700 0 0" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions on /etc/cron.daily are not correctly configured. Current $permissions, Expected 700 0 0."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
