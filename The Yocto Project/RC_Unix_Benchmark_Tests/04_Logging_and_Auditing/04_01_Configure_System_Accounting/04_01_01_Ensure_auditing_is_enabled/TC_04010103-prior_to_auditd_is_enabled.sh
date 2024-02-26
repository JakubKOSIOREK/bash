#!/bin/bash

TEST_TITLE="Ensure auditing for processes that start prior to auditd is enabled"
TEST_ID=04010103
SERVICE="auditd"
GRUB_CFG="/boot/grub/grub.cfg"


# Function to check if audit=1 is set in GRUB configuration
check_audit_setting() {
    grep "^\s*linux" "$GRUB_CFG" | grep -v "audit=1"
}

# Check if command -v for service is available
if ! command -v $SERVICE >/dev/null 2>&1; then
    echo "$TEST_ID:$TEST_TITLE:2:$SERVICE service not found"
    exit 2
fi

# Check if GRUB configuration file exists
if [ ! -f "$GRUB_CFG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:GRUB configuration file not found"
    exit 2
fi

# Check for audit=1 setting in GRUB configuration
if check_audit_setting; then
    echo "$TEST_ID:$TEST_TITLE:1:audit=1 parameter not set for all linux entries in GRUB configuration"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
