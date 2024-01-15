#!/bin/bash

TEST_TITLE="Ensure journald is configured to compress large log files"
TEST_ID=04020202
JOURNALD_CONF="/etc/systemd/journald.conf"

# Function to check if Compress is set to yes
check_compress_large_files() {
    if grep -qE '^Compress=yes' "$JOURNALD_CONF"; then
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

# Check if Compress is correctly configured
if check_compress_large_files; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1: Compress is not correctly configured"
    exit 1
fi
