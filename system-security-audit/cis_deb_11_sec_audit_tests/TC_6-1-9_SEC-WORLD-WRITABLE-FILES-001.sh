#!/bin/bash

test_id="SEC-WORLD-WRITABLE-FILES-001"
test_name="Ensure no world writable files exist"
test_fail_messages=() # Tablica na komunikaty o błędach

script_path="$0"
test_file=$(basename "$script_path")

# Znajdowanie plików z uprawnieniami do zapisu dla wszystkich
files=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)

exit_status=0

if [ -n "$files" ]; then
    # Dodawanie każdego znalezionego pliku do tablicy komunikatów o błędach
    while IFS= read -r file; do
        test_fail_messages+=("World writable file found: $file")
    done <<< "$files"
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
fi

exit $exit_status
