#!/bin/bash

TEST_TITLE="Ensure nodev option set on /tmp partition"
TEST_ID=010103
MOUNT_POINT="/tmp"

# Check if the mount point is configured with nodev
if mount | grep -E "\\s${MOUNT_POINT}\\s" | grep 'nodev' &> /dev/null; then
    NODEV_STATUS="set"
else
    NODEV_STATUS="not_set"
fi

# Evaluate results
if [ "$NODEV_STATUS" = "set" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
elif [ "$NODEV_STATUS" = "not_set" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:The nodev option is not set for ${MOUNT_POINT}."
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:2:Mount point ${MOUNT_POINT} not found or not configured correctly."
    exit 2
fi
