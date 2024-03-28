#!/bin/bash

test_id="SEC-ISSUE-CONFIGURED-PROPERLY-001"
test_name="Ensure local login warning banner is configured properly"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy plik /etc/issue istnieje
if [ ! -f /etc/issue ]; then
    echo "N/A;$test_id;$test_name;"
    exit 0
fi

# Sprawdzenie, czy /etc/issue zawiera niedozwolone informacje
os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')

if grep -E -i -q "(\\\v|\\\r|\\\m|\\\s|$os_id)" /etc/issue &> /dev/null; then
    test_fail_messages+=(" - Plik /etc/issue zawiera niedozwolone informacje o systemie.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;${test_fail_messages[*]}"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
