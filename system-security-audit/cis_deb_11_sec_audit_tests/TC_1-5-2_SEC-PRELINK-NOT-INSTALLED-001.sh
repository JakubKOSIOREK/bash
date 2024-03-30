#!/bin/bash

test_id="SEC-PRELINK-NOT-INSTALLED-001"
test_name="Ensure prelink is not installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy prelink jest zainstalowany
if dpkg-query -W -f='${Status}' prelink 2>/dev/null | grep -q "ok installed"; then
    test_fail_messages+=("Pakiet prelink jest zainstalowany.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
