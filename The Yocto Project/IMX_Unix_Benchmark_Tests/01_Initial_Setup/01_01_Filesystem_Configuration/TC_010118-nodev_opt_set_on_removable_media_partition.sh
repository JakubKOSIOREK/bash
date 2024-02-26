#!/bin/bash

TEST_TITLE="Ensure nodev option set on removable media partitions"
TEST_ID=010118

# Defined mount points
#MOUNT_POINTS=("/mnt/usb1" "/mnt/usb2" "/mnt/sdcard")
MOUNT_POINTS=()


# Initialize the test result as pass
TEST_RESULT=0

# Check that the nodev option is set for each mount point
for MOUNT_POINT in "${MOUNT_POINTS[@]}"; do
    if mount | grep -E "\\s${MOUNT_POINT}\\s" | grep 'nodev' &> /dev/null; then
        # Pass for this mount point
        continue
    else
        # Fail for this mount point
        echo "$TEST_ID:$TEST_TITLE:1:The nodev option is not set for ${MOUNT_POINT}."
        TEST_RESULT=1
        break
    fi
done

# Final result
if [ "$TEST_RESULT" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    exit 1
fi
