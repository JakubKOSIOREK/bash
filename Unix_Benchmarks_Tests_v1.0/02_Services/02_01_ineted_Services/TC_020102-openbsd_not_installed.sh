#!/bin/bash

PACKAGE="openbsd-inetd"
TEST_ID=020102
TEST_TITLE="Ensure ${PACKAGE} is not installed"

# Function to check package status
check_package_status() {
    local manager=$1
    case $manager in
        dpkg)
            dpkg -l "$PACKAGE" &>/dev/null && return 0
            ;;
        rpm)
            rpm -q "$PACKAGE" &>/dev/null && return 0
            ;;
        yum | dnf)
            $manager list installed "$PACKAGE" &>/dev/null && return 0
            ;;
    esac
    return 1
}

# Check for package managers and package status
PACKAGE_MANAGER_FOUND=""
for manager in dpkg rpm yum dnf; do
    if command -v $manager &>/dev/null; then
        PACKAGE_MANAGER_FOUND=$manager
        check_package_status $manager && PACKAGE_STATUS="installed"
        break
    fi
done

# Evaluate results
if [ -z "$PACKAGE_MANAGER_FOUND" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:No package manager found"
    exit 2
elif [ -z "$PACKAGE_STATUS" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Package '$PACKAGE' is installed"
    exit 1
fi
