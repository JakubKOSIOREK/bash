#!/bin/bash

TEST_TITLE="Ensure AppArmor is enabled in the bootloader configuration"
TEST_ID=01070102
GRUB_CFG="/boot/grub/grub.cfg"
PARAMETERS=("apparmor=1" "security=apparmor")
ALL_CHECKS_PASSED=true

# Check if AppArmor is not implemented
if ! command -v aa-status &>/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:2:AppArmor is not installed."
    exit 2
fi

# Function to check for parameters in GRUB configuration
check_grub_config() {
    local parameter=$1
    if [ ! -f "$GRUB_CFG" ]; then
        ALL_CHECKS_PASSED=false
        return
    fi

    if grep -P "^\s*linux" "$GRUB_CFG" | grep -v "$parameter" &> /dev/null; then
        ALL_CHECKS_PASSED=false
    fi
}

# Function to check for parameters in kernel command line
check_cmdline() {
    local parameter=$1
    if ! cat /proc/cmdline | grep -v "$parameter" &> /dev/null; then
    ALL_CHECKS_PASSED=false
    fi
}

# Iterate over each parameter and check both GRUB configuration and kernel command line
for parameter in "${PARAMETERS[@]}"; do
    check_grub_config "$parameter"
    check_cmdline "$parameter"
done

# Final evaluation
if $ALL_CHECKS_PASSED; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:AppArmor is not enabled."
    exit 1
fi
