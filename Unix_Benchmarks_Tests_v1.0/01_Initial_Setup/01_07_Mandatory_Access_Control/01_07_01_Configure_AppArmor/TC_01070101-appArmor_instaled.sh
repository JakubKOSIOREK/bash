#!/bin/bash

TEST_TITLE="Ensure AppArmor is installed"
TEST_ID=01070101
PACKAGES=("apparmor" "apparmor-utils")

# Check if AppArmor packages are installed
for package in ${PACKAGES[@]}; do
    if ! dpkg -s $package &> /dev/null; then
        echo "$TEST_ID:$TEST_TITLE:1:$package is not installed"
        exit 1
    fi
done

echo "$TEST_ID:$TEST_TITLE:0:All required packages are installed"
exit 0
