#!/bin/bash

TEST_TITLE="Ensure mounting of freevxfs filesystems is disabled"
TEST_ID=01010101
MODULE="freevxfs"

# Improved module status check function
check_module_status() {
    if lsmod | grep -q "$MODULE"; then
        echo "loaded"
    elif modprobe -n -v "$MODULE" 2>/dev/null | grep -q 'install /bin/true'; then
        echo "disabled"
    elif modprobe -n -v "$MODULE" 2>/dev/null; then
        echo "not_loaded"
    else
        echo "not_found"
    fi
}

MODULE_STATUS=$(check_module_status)

case $MODULE_STATUS in
    disabled)
        echo "$TEST_ID:$TEST_TITLE:0" # Pass
        exit 0
        ;;
    loaded)
        echo "$TEST_ID:$TEST_TITLE:1" # Fail
        exit 1
        ;;
    *)
        echo "$TEST_ID:$TEST_TITLE:2:Module $MODULE not found or not implemented" # Not implemented
        exit 2
        ;;
esac
