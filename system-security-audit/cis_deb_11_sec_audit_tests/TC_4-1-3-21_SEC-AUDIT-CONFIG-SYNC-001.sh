#!/bin/bash

test_id="SEC-AUDIT-CONFIG-SYNC-001"
test_name="Ensure running and on disk audit configuration is the same"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy narzędzie augenrules jest dostępne
if ! command -v augenrules &> /dev/null; then
    test_fail_messages+=("Narzędzie augenrules nie jest dostępne.")
    exit_status=1
else
    # Wykonanie augenrules --check do sprawdzenia konfiguracji
    check_result=$(augenrules --check 2>&1)

    if [[ $check_result != *'No change'* ]]; then
        test_fail_messages+=("Konfiguracja audytu na dysku różni się od bieżącej.")
        test_fail_messages+=("Detale: $check_result")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=$'\n'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
