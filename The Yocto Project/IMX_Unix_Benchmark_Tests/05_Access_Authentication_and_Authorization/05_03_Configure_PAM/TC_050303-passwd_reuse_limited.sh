#!/bin/bash
TEST_TITLE="Ensure password reuse is limited"
TEST_ID=050303
EXPECTED_REMEMBER_COUNT=5

# Define directories to search for the pam_pwhistory.so module
PAM_MODULES_DIRECTORIES=("/")

# Check for presence of pam_pwhistory related module file
module_found=false
for dir in "${PAM_MODULES_DIRECTORIES[@]}"; do
    if find "$dir" -name pam_pwhistory.so &>/dev/null; then
        module_found=true
        break
    fi
done

if ! $module_found; then
    echo "$TEST_ID:$TEST_TITLE:2:pam_pwhistory module is not installed or not found"
    exit 2
fi

# Check for pam_pwhistory configuration in common-password
pwhistory_conf=$(grep -E '^password\s+required\s+pam_pwhistory.so' /etc/pam.d/common-password)

# If pam_pwhistory configuration is not found
if [ -z "$pwhistory_conf" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:pam_pwhistory.so not configured in /etc/pam.d/common-password"
    exit 1
fi

# Extract 'remember' value from pam_pwhistory.so configuration
remember_count=0
if [[ "$pwhistory_conf" =~ remember=([0-9]+) ]]; then
    remember_count="${BASH_REMATCH[1]}"
fi

if [ "$remember_count" -lt "$EXPECTED_REMEMBER_COUNT" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Password remember count is less than expected."
    exit 1
fi

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
