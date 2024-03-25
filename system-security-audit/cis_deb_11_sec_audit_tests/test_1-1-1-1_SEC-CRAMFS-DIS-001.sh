#!/bin/bash

module="cramfs"
test_id="SEC-CRAMFS-DIS-001"
test_name="Ensure mounting of $module filesystems is disabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy moduł jest załadowany
if lsmod | grep -q $module; then
    test_fail_messages+=(" - Moduł $module jest załadowany! To niezgodne z zaleceniami.")
    exit_status=1
else
    echo "PASS;$test_id;$test_name;"
    exit 0
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
echo "FAIL;$test_id;$test_name;$test_fail_message"

exit $exit_status
