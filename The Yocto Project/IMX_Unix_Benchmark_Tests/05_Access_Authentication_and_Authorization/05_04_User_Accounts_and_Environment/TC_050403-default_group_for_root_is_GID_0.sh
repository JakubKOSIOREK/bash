#!/bin/bash
TEST_TITLE="Ensure default group for the root account is GID 0"
TEST_ID=050403

# Get the current GID of the root user
current_gid=$(grep "^root:" /etc/passwd | cut -f4 -d:)

# Check if the current GID is 0
if [ "$current_gid" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1: The default group for root is not GID 0. Current GID $current_gid"
fi
