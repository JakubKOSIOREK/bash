#!/bin/bash

test_id="SEC-DUPLICATE-GIDS-001"
test_name="Ensure no duplicate GIDs exist"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie duplikatów GID
duplicate_gids=$(cut -d: -f3 /etc/group | sort | uniq -d)

# Sprawdzanie, czy znaleziono jakiekolwiek duplikaty GID
if [ -n "$duplicate_gids" ]; then
    while read -r gid; do
        test_fail_messages+=("Duplicate GID ($gid) in /etc/group")
    done <<< "$duplicate_gids"
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
