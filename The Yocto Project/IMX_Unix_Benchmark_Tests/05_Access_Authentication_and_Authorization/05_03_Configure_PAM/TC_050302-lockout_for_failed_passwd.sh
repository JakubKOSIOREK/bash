#!/bin/bash
TEST_TITLE="Ensure lockout for failed password attempts is configured"
TEST_ID=050302

# Define directories to search for the pam_tally2.so module
PAM_MODULES_DIRECTORIES=("/")

# Check for presence of pam_tally2 related module file
module_found=false
for dir in "${PAM_MODULES_DIRECTORIES[@]}"; do
    if find "$dir" -name pam_tally2.so &>/dev/null; then
        module_found=true
        break
    fi
done

if ! $module_found; then
    echo "$TEST_ID:$TEST_TITLE:2:pam_tally2 module is not installed or not found"
    exit 2
fi

# Check for pam_tally2 configuration in common-auth
common_auth_conf=$(grep "pam_tally2" /etc/pam.d/common-auth)
expected_common_auth="auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900"

if [[ "$common_auth_conf" != "$expected_common_auth" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Incorrect pam_tally2 configuration in /etc/pam.d/common-auth"
    exit 1
fi

# Check for pam_tally2 and pam_deny configuration in common-account
common_account_conf=$(grep -E "pam_(tally2|deny)\.so" /etc/pam.d/common-account)

if [[ "$common_account_conf" != *pam_deny.so* ]] || [[ "$common_account_conf" != *pam_tally2.so* ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Incorrect configuration in /etc/pam.d/common-account"
    exit 1
fi

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
