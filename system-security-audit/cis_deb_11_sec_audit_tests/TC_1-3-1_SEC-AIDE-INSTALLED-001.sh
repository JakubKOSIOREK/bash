#!/bin/bash

test_id="SEC-AIDE-INSTALLED-001"
test_name="Ensure AIDE is installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy AIDE jest zainstalowany
if ! command -v aide &> /dev/null; then
    test_fail_messages+=("AIDE nie jest zainstalowany.")
    exit_status=1
else
    echo "PASS;${test_id};${test_file};${test_name};"
    exit 0
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
fi

exit $exit_status
