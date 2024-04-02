#!/bin/bash

test_id="SEC-GROUPS-IN-PASSWD-EXIST-IN-GROUP-001"
test_name="Ensure all groups in /etc/passwd exist in /etc/group"
test_fail_messages=() # Tablica na komunikaty o błędach
script_path="$0"
test_file=$(basename "$script_path")
exit_status=0

# Przechodzenie przez unikalne ID grup z /etc/passwd i sprawdzanie ich obecności w /etc/group
while IFS= read -r gid; do
    if ! grep -q -P "^.*?:[^:]*:$gid:" /etc/group; then
        test_fail_messages+=("Grupa $gid jest wymieniona w /etc/passwd, ale nie istnieje w /etc/group")
        exit_status=1
    fi
done < <(cut -s -d: -f4 /etc/passwd | sort -u)

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
