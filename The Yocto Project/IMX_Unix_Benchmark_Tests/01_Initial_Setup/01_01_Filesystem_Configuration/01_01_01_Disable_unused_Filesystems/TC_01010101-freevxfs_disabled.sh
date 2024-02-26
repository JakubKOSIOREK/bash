#!/bin/bash

TEST_TITLE="Ensure mounting of freevxfs filesystems is disabled"
TEST_ID=01010101
MODULE="freevxfs"

# Function to check module information
check_module_info() {
    if modinfo "$MODULE" &>/dev/null; then
        echo "available"
    else
        echo "not_available"
    fi
}

MODULE_INFO_STATUS=$(check_module_info)

case $MODULE_INFO_STATUS in
    not_available)
        echo "$TEST_ID:$TEST_TITLE:0" # Pass
        exit 0
        ;;
    available)
        echo "$TEST_ID:$TEST_TITLE:1" # Fail
        exit 1
        ;;
esac
