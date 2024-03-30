#!/bin/bash

test_id="SEC-VARLOG-NODEV-001"
test_name="Ensure nodev option set on /var/log partition"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy opcja nodev jest ustawiona na partycji /var/log
if mount | grep ' on /var/log ' | grep -q 'nodev'; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_messages+=("Opcja nodev nie jest ustawiona na partycji /var/log.")
    exit_status=1
fi

# Raportowanie wyniku tylko jeśli test się nie powiódł
if [ $exit_status -ne 0 ]; then
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
