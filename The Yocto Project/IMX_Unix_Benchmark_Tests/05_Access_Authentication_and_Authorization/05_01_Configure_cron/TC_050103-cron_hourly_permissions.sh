#!/bin/bash
TEST_TITLE="Ensure permissions on /etc/cron.hourly are configured"
TEST_ID=050103



# Check if /etc/cron.hourly directory exists
if [[ ! -d /etc/cron.hourly ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:/etc/cron.hourly directory does not exist"
    exit 2
fi

# Check permissions on /etc/cron.hourly
permissions=$(stat -c "%a %u %g" /etc/cron.hourly)

# If permissions are not 700 or owner is not root or group is not root, then test fails
if [[ $permissions != "700 0 0" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions on /etc/cron.hourly are not correctly configured. Current $permissions, Expected 700 0 0."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
