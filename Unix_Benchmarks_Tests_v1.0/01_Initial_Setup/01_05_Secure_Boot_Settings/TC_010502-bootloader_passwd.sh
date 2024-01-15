#!/bin/bash

TEST_TITLE="Ensure bootloader password is set"
GRUB_CFG="/boot/grub/grub.cfg"
TEST_ID=010502

# Check if GRUB configuration file exists
if [ ! -f "$GRUB_CFG" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:GRUB configuration file not found"
    exit 2
fi

# Check for superusers setting
if ! grep -q "^set superusers" "$GRUB_CFG"; then
    echo "$TEST_ID:$TEST_TITLE:1:Superusers not set in GRUB configuration"
    exit 1
fi

# Check for password setting
if ! grep -q "^password_pbkdf2" "$GRUB_CFG"; then
    echo "$TEST_ID:$TEST_TITLE:1:Bootloader password not set"
    exit 1
fi

echo "$TEST_ID:$TEST_TITLE:0"
exit 0
