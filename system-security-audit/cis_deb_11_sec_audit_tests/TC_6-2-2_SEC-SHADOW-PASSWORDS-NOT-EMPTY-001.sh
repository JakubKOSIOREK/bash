#!/bin/bash

test_id="SEC-SHADOW-PASSWORDS-NOT-EMPTY-001"
test_name="Ensure /etc/shadow password fields are not empty"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzanie, czy pola haseł w /etc/shadow nie są puste
empty_password_accounts=$(awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow)

# Sprawdzenie, czy znaleziono jakiekolwiek konta z pustymi polami haseł
if [ -n "$empty_password_accounts" ]; then
    test_fail_messages+=("$empty_password_accounts")
    exit_status=1
fi

# Kompilacja jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
