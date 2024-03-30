#!/bin/bash

module="cramfs"
test_id="SEC-CRAMFS-DIS-001"
test_name="Ensure mounting of $module filesystems is disabled"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy moduł jest załadowany
if lsmod | grep -q "$module"; then
    test_fail_messages+=("Moduł $module jest załadowany! To niezgodne z zaleceniami.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
