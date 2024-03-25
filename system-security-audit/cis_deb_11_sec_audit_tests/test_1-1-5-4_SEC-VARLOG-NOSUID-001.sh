#!/bin/bash

test_id="SEC-VARLOG-NOSUID-001"
test_name="Ensure nosuid option set on /var/log partition"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy opcja nosuid jest ustawiona na partycji /var/log
if mount | grep ' on /var/log ' | grep -q 'nosuid'; then
    echo "PASS;$test_id;$test_name;"
    exit 0
else
    test_fail_messages+=(" - Opcja nosuid nie jest ustawiona na partycji /var/log.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
echo "FAIL;$test_id;$test_name;$test_fail_message"

exit $exit_status