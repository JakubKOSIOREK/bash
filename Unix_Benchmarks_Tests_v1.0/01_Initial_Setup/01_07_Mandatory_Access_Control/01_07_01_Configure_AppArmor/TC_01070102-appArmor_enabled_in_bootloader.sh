#!/bin/bash

TEST_TITLE="Ensure AppArmor is enabled in the bootloader configuration"
TEST_ID=01070102
GRUB_CFG="/boot/grub/grub.cfg"

# Function to check for missing parameters
check_grub_config() {
    local parameter=$1
    if grep -P "^\s*linux" "$GRUB_CFG" | grep -v "$parameter" &> /dev/null; then
        echo "$TEST_ID:$TEST_TITLE:1:Some entries in GRUB configuration are missing $parameter"
        exit 1
    fi
}

# Check if the GRUB configuration file exists
if [ ! -f "$GRUB_CFG" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:GRUB configuration file not found"
    exit 1
fi

# Check for AppArmor parameters in GRUB configuration
check_grub_config "apparmor=1"
check_grub_config "security=apparmor"

echo "$TEST_ID:$TEST_TITLE:0:AppArmor is correctly enabled in GRUB configuration"
exit 0
