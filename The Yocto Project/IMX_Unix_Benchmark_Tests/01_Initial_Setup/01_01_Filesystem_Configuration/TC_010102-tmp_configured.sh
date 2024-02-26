#!/bin/bash

TEST_TITLE="Ensure /tmp is configured"
TEST_ID=010102
MOUNT_POINT="/tmp"

# Check if the mount point is configured
if mount | grep -E "\\s${MOUNT_POINT}\\s" &> /dev/null; then
    MOUNT_POINT_STATUS="configured"
else
    MOUNT_POINT_STATUS="not_configured"
fi

# Check if the mount point is in /etc/fstab
if grep -E "\\s${MOUNT_POINT}\\s" /etc/fstab | grep -E -v '^\\s*#' &> /dev/null; then
    FSTAB_STATUS="configured"
else
    FSTAB_STATUS="not_configured"
fi

# Check if the mount point is enabled
SYSTEMCTL_MOUNT_STATUS=$(systemctl is-enabled tmp.mount)

if [[ $SYSTEMCTL_MOUNT_STATUS == "enabled" ]]; then
    SYSTEMCTL_STATUS="enabled"
else
    SYSTEMCTL_STATUS="not_enabled"
fi

# Evaluate results
if [ "$MOUNT_POINT_STATUS" = "configured" ] && [ "$FSTAB_STATUS" = "configured" ] || [ "$SYSTEMCTL_STATUS" = "enabled" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:${MOUNT_POINT} is not configured correctly in /etc/fstab or systemd tmp.mount is not enabled."
    exit 2
fi
