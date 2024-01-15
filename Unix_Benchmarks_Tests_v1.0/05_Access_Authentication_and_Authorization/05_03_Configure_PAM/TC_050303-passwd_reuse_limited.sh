#!/bin/bash
TEST_TITLE="Ensure password reuse is limited"
TEST_ID=050303
EXPECTED_REMEMBER_COUNT=5

# Function to extract 'remember' value from pam_pwhistory.so configuration
extract_remember_value() {
    local line=$1
    if [[ "$line" =~ remember=([0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "0"
    fi
}

# Check for pam_pwhistory configuration in common-password
pwhistory_conf=$(grep -E '^password\s+required\s+pam_pwhistory.so' /etc/pam.d/common-password)

# If pam_pwhistory configuration is not found
if [ -z "$pwhistory_conf" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:pam_pwhistory.so not configured in /etc/pam.d/common-password"
    exit 1
fi

# Extract and check 'remember' value
remember_count=$(extract_remember_value "$pwhistory_conf")

if [ "$remember_count" -lt "$EXPECTED_REMEMBER_COUNT" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Password remember count is less than expected. Found $remember_count, Expected $EXPECTED_REMEMBER_COUNT."
    exit 1
fi

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
