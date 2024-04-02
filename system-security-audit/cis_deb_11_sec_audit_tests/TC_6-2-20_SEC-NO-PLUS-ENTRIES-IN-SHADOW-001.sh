#!/bin/bash

test_id="SEC-NO-PLUS-ENTRIES-IN-SHADOW-001"
test_name="Ensure no legacy '+' entries exist in /etc/shadow"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie przestarzałych wpisów zaczynających się od '+'
plus_prefixed_entries=$(grep '^\+:' /etc/shadow)

# Sprawdzanie, czy znaleziono jakiekolwiek przestarzałe wpisy
if [ -n "$plus_prefixed_entries" ]; then
    test_fail_messages+=("Legacy '+' entries found in /etc/shadow: $(echo "$plus_prefixed_entries" | xargs)")
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
