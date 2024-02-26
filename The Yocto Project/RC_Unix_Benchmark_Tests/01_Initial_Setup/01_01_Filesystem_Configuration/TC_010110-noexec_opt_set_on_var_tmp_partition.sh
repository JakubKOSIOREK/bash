#!/bin/bash

TEST_TITLE="Ensure noexec option set on /var/tmp partition"
TEST_ID=010110
MOUNT_POINT="/var/tmp"

# Check if the mount point directory exists
if ! ls -ld $MOUNT_POINT &> /dev/null; then
    echo "$TEST_ID:$TEST_TITLE:2:${MOUNT_POINT} >> No such file or directory."
    exit 2
fi

# Check if the mount point is configured with noexec
if mount | grep -E "\\s${MOUNT_POINT}\\s" | grep 'noexec' &> /dev/null; then
    NOEXEC_STATUS="set"
else
    NOEXEC_STATUS="not_set"
fi

# Evaluate results
if [ "$NOEXEC_STATUS" = "set" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
elif [ "$NOEXEC_STATUS" = "not_set" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:The noexec option is not set for ${MOUNT_POINT}."
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:2:Mount point ${MOUNT_POINT} not found or not configured correctly."
    exit 2
fi
