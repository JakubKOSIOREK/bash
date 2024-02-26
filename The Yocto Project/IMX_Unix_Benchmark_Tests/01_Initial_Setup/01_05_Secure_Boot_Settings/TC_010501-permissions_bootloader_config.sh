#!/bin/bash
TEST_TITLE="Ensure permissions on bootloader config are configured"
TEST_ID=010501

# Check if bootloader config file exists
if [[ ! -f /boot/grub/grub.cfg ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:Bootloader config file does not exist"
    exit 2
fi

# Check permissions on bootloader config
permissions=$(stat -c "%a %u %g" /boot/grub/grub.cfg)

# If permissions are not 400 or owner is not root or group is not root, then test fails
if [[ $permissions != "400 0 0" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions on bootloader config are not correctly configured. Current $permissions, Expected 400 0 0."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
