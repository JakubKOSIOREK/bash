#!/usr/bin/env bash

test_id="SEC-FAILED-PASSWORD-ATTEMPTS-LOCKOUT-001"
test_name="Ensure lockout for failed password attempts is configured"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie konfiguracji pam_tally2 w common-auth
common_auth_conf=$(grep "pam_tally2" /etc/pam.d/common-auth)
expected_common_auth="auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900"

if [[ "$common_auth_conf" != "$expected_common_auth" ]]; then
    test_fail_messages+=("Incorrect pam_tally2 configuration in /etc/pam.d/common-auth.")
    exit_status=1
fi

# Sprawdzenie konfiguracji pam_tally2 i pam_deny w common-account
common_account_conf=$(grep -E "pam_(tally2|deny)\.so" /etc/pam.d/common-account)
expected_common_account="account requisite pam_deny.so
account required pam_tally2.so"

if [[ "$common_account_conf" != *pam_deny.so* ]] || [[ "$common_account_conf" != *pam_tally2.so* ]]; then
    test_fail_messages+=("Incorrect configuration in /etc/pam.d/common-account.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
