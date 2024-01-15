#!/bin/bash

PACKAGE="xinetd"
TEST_TITLE="Ensure ${PACKAGE} is not installed"
TEST_ID=020101

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

# Function to check service status
check_service_status() {
    if systemctl is-active --quiet "$PACKAGE"; then
        echo "active"
    else
        echo "disabled"
    fi
}

# Evaluate results
if [ -z "$PACKAGE_MANAGER_FOUND" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:No package manager found"
    exit 1
elif [ -z "$PACKAGE_STATUS" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    SERVICE_STATUS=$(check_service_status)
    echo "$TEST_ID:$TEST_TITLE:1:Package '$PACKAGE' is installed and status is $SERVICE_STATUS"
    exit 1
fi
