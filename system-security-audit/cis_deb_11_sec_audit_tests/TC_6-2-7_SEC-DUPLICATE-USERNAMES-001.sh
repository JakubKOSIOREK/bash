#!/bin/bash

test_id="SEC-DUPLICATE-USERNAMES-001"
test_name="Ensure no duplicate user names exist"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie duplikatów nazw użytkowników
duplicate_usernames=$(cut -d: -f1 /etc/passwd | sort | uniq -d)

# Sprawdzenie, czy znaleziono jakiekolwiek duplikaty nazw użytkowników
if [ -n "$duplicate_usernames" ]; then
    while read -r username; do
        test_fail_messages+=("Duplicate login name $username in /etc/passwd")
    done <<< "$duplicate_usernames"
    exit_status=1
fi

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};Duplikaty nazw użytkowników:$test_fail_message"
fi

exit $exit_status
