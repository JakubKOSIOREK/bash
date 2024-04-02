#!/bin/bash

test_id="SEC-ONLY-ROOT-UID0-001"
test_name="Ensure root is the only UID 0 account"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie kont z UID 0
uid_0_accounts=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)

# Sprawdzanie, czy znaleziono tylko konto "root"
for account in $uid_0_accounts; do
    if [ "$account" != "root" ]; then
        test_fail_messages+=("$account account has UID 0 but is not root")
        exit_status=1
    fi
done

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
