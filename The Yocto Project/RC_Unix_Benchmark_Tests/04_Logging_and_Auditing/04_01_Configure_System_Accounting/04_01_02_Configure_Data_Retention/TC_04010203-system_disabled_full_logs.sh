#!/bin/bash

TEST_TITLE="Ensure system is disabled when audit logs are full"
TEST_ID=04010203
AUDIT_CONFIG="/etc/audit/auditd.conf"
EXPECTED_SPACE_LEFT_ACTION="email"
EXPECTED_ACTION_MAIL_ACCT="root"
EXPECTED_ADMIN_SPACE_LEFT_ACTION="halt"

# Check if the audit configuration file exists
if [ ! -f "$AUDIT_CONFIG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit configuration file not found"
    exit 2
fi

# Function to check configuration setting
check_config_setting() {
    local key=$1
    local expected_value=$2
    local actual_value=$(grep "^$key\s*=" "$AUDIT_CONFIG" | awk -F '=' '{print $2}' | xargs)

    if [ "$actual_value" != "$expected_value" ]; then
        echo "$TEST_ID:$TEST_TITLE:1:$key is not set to $expected_value"
        return 1
    fi
    return 0
}

# Check space_left_action
check_config_setting "space_left_action" "$EXPECTED_SPACE_LEFT_ACTION"
result=$?
if [ $result -ne 0 ]; then
    exit 1
fi

# Check action_mail_acct
check_config_setting "action_mail_acct" "$EXPECTED_ACTION_MAIL_ACCT"
result=$?
if [ $result -ne 0 ]; then
    exit 1
fi

# Check admin_space_left_action
check_config_setting "admin_space_left_action" "$EXPECTED_ADMIN_SPACE_LEFT_ACTION"
result=$?
if [ $result -ne 0 ]; then
    exit 1
fi

echo "$TEST_ID:$TEST_TITLE:0"
exit 0
