#!/bin/bash

TEST_TITLE="Ensure mounting of FAT filesystems is limited"
TEST_ID=01010107
MODULE="vfat"

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

# Check if the module is in use
MODULE_IN_USE="no"
if grep -E -i "\\s${MODULE}\\s" /etc/fstab &> /dev/null; then
    MODULE_IN_USE="yes"
fi

# Evaluate results
case $MODULE_STATUS in
    disabled)
        if [ "$MODULE_IN_USE" = "no" ]; then
            echo "$TEST_ID:$TEST_TITLE:0"
            exit 0
        else
            echo "$TEST_ID:$TEST_TITLE:1:Module $MODULE is disabled but in use"
            exit 1
        fi
        ;;
    loaded)
        if [ "$MODULE_IN_USE" = "yes" ]; then
            echo "$TEST_ID:$TEST_TITLE:1:Module $MODULE is loaded and in use"
            exit 1
        else
            echo "$TEST_ID:$TEST_TITLE:1:Module $MODULE is loaded but not in use"
            exit 1
        fi
        ;;
    *)
        echo "$TEST_ID:$TEST_TITLE:2:Module $MODULE not found or not implemented"
        exit 2
        ;;
esac
