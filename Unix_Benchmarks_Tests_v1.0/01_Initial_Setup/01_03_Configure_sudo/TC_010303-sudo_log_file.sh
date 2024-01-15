#!/bin/bash
TEST_TITLE="Ensure sudo log file exists"
TEST_ID=010303

# Check if sudo has a custom log file configured
sudo_config=$(grep -Ei '^\s*Defaults\s+logfile=\S+' /etc/sudoers /etc/sudoers.d/* 2>&1)

# If no configuration is found, then test fails
if [[ -z $sudo_config ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:sudo does not have a custom log file configured"
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
