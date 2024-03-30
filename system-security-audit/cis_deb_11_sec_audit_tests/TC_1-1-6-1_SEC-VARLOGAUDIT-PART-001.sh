#!/bin/bash

test_id="SEC-VARLOGAUDIT-PART-001"
test_name="Ensure separate partition exists for /var/log/audit"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy /var/log/audit jest zamontowany jako osobna partycja
if findmnt --kernel /var/log/audit > /dev/null; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_messages+=("/var/log/audit nie jest zamontowany jako osobna partycja.")
    exit_status=1
fi

# Raportowanie wyniku tylko jeśli test się nie powiódł
if [ $exit_status -ne 0 ]; then
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
