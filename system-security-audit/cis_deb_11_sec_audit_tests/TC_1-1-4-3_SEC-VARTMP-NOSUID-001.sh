#!/bin/bash

test_id="SEC-VARTMP-NOSUID-001"
test_name="Ensure nosuid option set on /var/tmp partition"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy opcja nosuid jest ustawiona na partycji /var/tmp
if mount | grep ' on /var/tmp ' | grep -q 'nosuid'; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_messages+=("Opcja nosuid nie jest ustawiona na partycji /var/tmp.")
    exit_status=1
fi

# Raportowanie wyniku tylko jeśli test się nie powiódł
if [ $exit_status -ne 0 ]; then
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
