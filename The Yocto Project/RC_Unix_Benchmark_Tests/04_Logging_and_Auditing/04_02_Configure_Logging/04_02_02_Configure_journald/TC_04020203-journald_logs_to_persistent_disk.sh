#!/bin/bash

TEST_TITLE="Ensure journald is configured to write logfiles to persistent disk"
TEST_ID=04020203
JOURNALD_CONF="/etc/systemd/journald.conf"

# Function to check if Storage is set to persistent
check_storage_persistent() {
    if grep -qE '^Storage=persistent' "$JOURNALD_CONF"; then
        return 0
    else
        return 1
    fi
}

# Check if journald.conf exists
if [ ! -f "$JOURNALD_CONF" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: journald configuration file not found"
    exit 2
fi

# Check if Storage is correctly configured
if check_storage_persistent; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1: Storage is not configured to persistent"
    exit 1
fi
