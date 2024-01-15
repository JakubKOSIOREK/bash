#!/bin/bash

TEST_TITLE="Ensure separate partition exists for /var/log"
TEST_ID=010111
MOUNT_POINT="/var/log"

# Check if the mount point is configured
if mount | grep -E "\\s${MOUNT_POINT}\\s" &> /dev/null; then
    MOUNT_POINT_STATUS="configured"
else
    MOUNT_POINT_STATUS="not_configured"
fi

# Evaluate results
if [ "$MOUNT_POINT_STATUS" = "configured" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
elif [ "$MOUNT_POINT_STATUS" = "not_configured" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:${MOUNT_POINT} is not mounted on a separate partition."
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:2:Mount point ${MOUNT_POINT} not found or not configured correctly."
    exit 2
fi
