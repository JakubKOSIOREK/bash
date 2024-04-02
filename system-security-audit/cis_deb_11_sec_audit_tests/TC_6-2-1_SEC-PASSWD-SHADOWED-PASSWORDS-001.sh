#!/bin/bash

test_id="SEC-PASSWD-SHADOWED-PASSWORDS-001"
test_name="Ensure accounts in /etc/passwd use shadowed passwords"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy wszystkie konta korzystają z cieniowanych haseł
non_shadowed_accounts=$(awk -F: '($2 != "x") {print $1 " is not set to shadowed passwords"}' /etc/passwd)

# Sprawdzenie, czy znaleziono jakiekolwiek konta bez cieniowanych haseł
if [ -n "$non_shadowed_accounts" ]; then
    test_fail_messages+=("$non_shadowed_accounts")
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
