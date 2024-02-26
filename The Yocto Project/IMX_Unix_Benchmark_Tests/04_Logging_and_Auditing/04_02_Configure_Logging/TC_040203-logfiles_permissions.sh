#!/bin/bash

TEST_TITLE="Ensure permissions on all logfiles are configured"
TEST_ID=040203
LOG_DIR="/var/log"

# Function to check permissions on log files and directories
check_logfile_permissions() {
    # Find command to search for files with incorrect permissions
    # Files should not be writable or executable by group/others
    # Directories should not be writable or executable by group/others
    local incorrect_files
    incorrect_files=$(find "$LOG_DIR" -type f ! -perm g-wx,o-rwx -o -type d ! -perm -g-wx,o-rwx)

    if [ -n "$incorrect_files" ]; then
        return 1
    fi
    return 0
}

# Check permissions on all log files
if check_logfile_permissions; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1: Some logfiles have incorrect permissions"
    exit 1
fi
