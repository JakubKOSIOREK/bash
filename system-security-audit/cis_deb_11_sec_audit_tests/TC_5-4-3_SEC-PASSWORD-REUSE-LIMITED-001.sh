#!/usr/bin/env bash

test_id="SEC-PASSWORD-REUSE-LIMITED-001"
test_name="Ensure password reuse is limited"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0
expected_remember_count=5

# Funkcja do ekstrakcji wartości 'remember' z konfiguracji pam_pwhistory.so
extract_remember_value() {
    local line=$1
    if [[ "$line" =~ remember=([0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "0"
    fi
}

# Sprawdzenie konfiguracji pam_pwhistory w common-password
pwhistory_conf=$(grep -E '^password\s+required\s+pam_pwhistory.so' /etc/pam.d/common-password)

# Jeśli konfiguracja pam_pwhistory nie została znaleziona
if [ -z "$pwhistory_conf" ]; then
    test_fail_messages+=("pam_pwhistory.so not configured in /etc/pam.d/common-password.")
    exit_status=1
else
    # Ekstrakcja i sprawdzenie wartości 'remember'
    remember_count=$(extract_remember_value "$pwhistory_conf")

    if [ "$remember_count" -lt "$expected_remember_count" ]; then
        test_fail_messages+=("Password remember count is less than expected. Found $remember_count, Expected $expected_remember_count.")
        exit_status=1
    fi
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
