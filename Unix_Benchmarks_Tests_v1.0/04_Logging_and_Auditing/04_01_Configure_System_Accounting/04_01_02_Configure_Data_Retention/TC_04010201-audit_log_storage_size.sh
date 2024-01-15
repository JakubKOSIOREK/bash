#!/bin/bash

TEST_TITLE="Ensure audit log storage size is configured"
TEST_ID=04010201
AUDIT_CONFIG="/etc/audit/auditd.conf"
MIN_AUDIT_LOG_SIZE=16

# Check if the audit configuration file exists
if [ ! -f "$AUDIT_CONFIG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit configuration file not found"
    exit 2
fi

# Get the max_log_file setting value
max_log_file_size=$(grep "^max_log_file\s*=" "$AUDIT_CONFIG" | awk -F '=' '{print $2}' | xargs)

# Check if max_log_file is set and meets the minimum requirement
if [ -z "$max_log_file_size" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:max_log_file is not set in audit configuration"
    exit 1
elif [ "$max_log_file_size" -lt "$MIN_AUDIT_LOG_SIZE" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:max_log_file size is less than the minimum required ($MIN_AUDIT_LOG_SIZE MB)"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
