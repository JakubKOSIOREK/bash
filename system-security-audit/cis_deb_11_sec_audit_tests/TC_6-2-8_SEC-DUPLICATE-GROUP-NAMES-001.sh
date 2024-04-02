#!/bin/bash

test_id="SEC-DUPLICATE-GROUP-NAMES-001"
test_name="Ensure no duplicate group names exist"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie duplikatów nazw grup
duplicate_group_names=$(cut -d: -f1 /etc/group | sort | uniq -d)

# Sprawdzanie, czy znaleziono jakiekolwiek duplikaty nazw grup
if [ -n "$duplicate_group_names" ]; then
    while read -r group_name; do
        test_fail_messages+=("Duplicate group name $group_name in /etc/group")
    done <<< "$duplicate_group_names"
    exit_status=1
fi

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
