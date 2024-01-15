#!/bin/bash

TEST_TITLE="Ensure auditd is installed"
TEST_ID=04010101
PACKAGES=("auditd" "audispd-plugins")

# Function to check if package is installed
check_package_installed() {
    local package=$1
    if dpkg -s "$package" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Check if all required packages are installed
all_packages_installed=true
for package in "${PACKAGES[@]}"; do
    if ! check_package_installed "$package"; then
        echo "$TEST_ID:$TEST_TITLE:1:$package is not installed"
        all_packages_installed=false
        break # Exit the loop on first failure
    fi
done

# Final result
if $all_packages_installed; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:One or more packages are not installed"
    exit 1
fi
