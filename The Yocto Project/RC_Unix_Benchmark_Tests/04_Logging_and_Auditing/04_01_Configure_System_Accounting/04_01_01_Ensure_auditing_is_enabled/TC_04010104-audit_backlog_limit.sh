#!/bin/bash

TEST_TITLE="Ensure audit_backlog_limit is sufficient"
TEST_ID=04010104
SERVICE="auditd"
GRUB_CFG="/boot/grub/grub.cfg"
EXPECTED_MIN_LIMIT=8192

# Function to check the audit_backlog_limit in the GRUB configuration
check_audit_backlog_limit() {
    if grep -P "^\s*linux" "$GRUB_CFG" | grep -v "audit_backlog_limit=" &> /dev/null; then
        # If any linux line does not contain the audit_backlog_limit parameter
        return 1
    else
        # Check if all instances of audit_backlog_limit meet the expected minimum limit
        while IFS= read -r line; do
            if [[ "$line" =~ audit_backlog_limit=([0-9]+) ]]; then
                limit="${BASH_REMATCH[1]}"
                if [ "$limit" -lt "$EXPECTED_MIN_LIMIT" ]; then
                    return 1
                fi
            fi
        done < <(grep "audit_backlog_limit=" "$GRUB_CFG")
    fi
}

# Check if command -v for service is available
if ! command -v $SERVICE >/dev/null 2>&1; then
    echo "$TEST_ID:$TEST_TITLE:2:$SERVICE service not found"
    exit 2
fi

# Check if the GRUB configuration file exists
if [ ! -f "$GRUB_CFG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:GRUB configuration file not found"
    exit 2
fi

# Check the audit_backlog_limit setting in GRUB configuration
if check_audit_backlog_limit; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:audit_backlog_limit is not set properly in GRUB configuration"
    exit 1
fi
