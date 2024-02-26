#!/bin/bash

TEST_TITLE="Ensure audit logs are not automatically deleted"
TEST_ID=04010202
AUDIT_CONFIG="/etc/audit/auditd.conf"
EXPECTED_SETTING="keep_logs"

# Check if the audit configuration file exists
if [ ! -f "$AUDIT_CONFIG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit configuration file not found"
    exit 2
fi

# Get the max_log_file_action setting value
max_log_file_action=$(grep "^max_log_file_action\s*=" "$AUDIT_CONFIG" | awk -F '=' '{print $2}' | xargs)

# Check if max_log_file_action is set to keep_logs
if [ -z "$max_log_file_action" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:max_log_file_action is not set in audit configuration"
    exit 1
elif [ "$max_log_file_action" != "$EXPECTED_SETTING" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:max_log_file_action is not set to $EXPECTED_SETTING"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
