#!/bin/bash

TEST_TITLE="Ensure AppArmor is installed"
TEST_ID=01070101

# Initialize variables to store the status
aa_status_active=false
apparmor_service_active=false

# Check if AppArmor is active using aa-status
if aa-status &> /dev/null; then
    aa_status_active=true
fi

# Check if AppArmor service is active
if systemctl is-active apparmor.service &> /dev/null; then
    apparmor_service_active=true
fi

# Evaluate the overall test result based on the command output
if $aa_status_active || $apparmor_service_active; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:AppArmor is not installed or not active."
    exit 1
fi
