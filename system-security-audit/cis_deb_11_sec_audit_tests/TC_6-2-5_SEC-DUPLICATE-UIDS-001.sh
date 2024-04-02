#!/bin/bash

test_id="SEC-DUPLICATE-UIDS-001"
test_name="Ensure no duplicate UIDs exist"
test_fail_messages=() # Tablica na komunikaty o błędach
script_path="$0"
test_file=$(basename "$script_path")
exit_status=0

# Wyszukiwanie duplikatów UID
cut -d: -f3 /etc/passwd | sort -n | uniq -c | while read count uid; do
    if [ "$count" -gt 1 ]; then
        users=$(awk -F: '($3 == n) { print $1 }' n=$uid /etc/passwd | xargs)
        test_fail_messages+=("Duplicate UID ($uid): $users")
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
