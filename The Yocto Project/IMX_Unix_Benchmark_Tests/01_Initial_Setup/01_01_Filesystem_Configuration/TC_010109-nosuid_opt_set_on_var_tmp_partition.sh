#!/bin/bash

TEST_TITLE="Ensure nosuid option set on /var/tmp partition"
TEST_ID=010109

# command `df -h /var/tmp`` indicates `/var/tmp` is mounted as `/var/volatile`
MOUNT_POINT="/var/volatile"

# Check if the mount point is configured with nosuid
if mount | grep -E "\\s${MOUNT_POINT}\\s" | grep 'nosuid' &> /dev/null; then
    NOSUID_STATUS="set"
else
    NOSUID_STATUS="not_set"
fi

# Evaluate results
if [ "$NOSUID_STATUS" = "set" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
elif [ "$NOSUID_STATUS" = "not_set" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:The nosuid option is not set for ${MOUNT_POINT}."
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:2:Mount point ${MOUNT_POINT} not found or not configured correctly."
    exit 2
fi