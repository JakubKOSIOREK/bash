#!/bin/bash

TEST_TITLE="Ensure mounting of FAT filesystems is limited"
TEST_ID=01010107
MODULE="vfat"

# Function to check module information
check_module_info() {
    if modinfo "$MODULE" &>/dev/null; then
        if lsmod | grep -q "$MODULE"; then
            echo "loaded"
        else
            echo "available"
        fi
            
    else
        echo "not_available"
    fi
}

MODULE_INFO_STATUS=$(check_module_info)

case $MODULE_INFO_STATUS in
    available)
        echo "$TEST_ID:$TEST_TITLE:0" # Pass
        exit 0
        ;;
    not_available)
        echo "$TEST_ID:$TEST_TITLE:2: Module 'vfat' not found" # NOT IMPLEMENTED
        exit 1
        ;;
    loaded)
        echo "$TEST_ID:$TEST_TITLE:1" # Fail
        exit 1
        ;;
esac

