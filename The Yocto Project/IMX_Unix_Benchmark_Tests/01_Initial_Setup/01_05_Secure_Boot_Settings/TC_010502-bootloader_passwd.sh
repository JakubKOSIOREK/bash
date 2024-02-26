#!/bin/bash

TEST_TITLE="Ensure bootloader password is set"
TEST_ID=010502

# Check if GRUB configuration file exists
if [[ ! -f /boot/grub/grub.cfg ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:Bootloader config file does not exist"
    exit 2
fi

# Check for superusers setting
if ! grep -q "^set superusers" "$GRUB_CFG"; then
    echo "$TEST_ID:$TEST_TITLE:1:Superusers not set in bootloader configuration"
    exit 1
fi

# Check for password setting
if ! grep -q "^password_pbkdf2" "$GRUB_CFG"; then
    echo "$TEST_ID:$TEST_TITLE:1:Bootloader password not set"
    exit 1
fi

echo "$TEST_ID:$TEST_TITLE:0"
exit 0
