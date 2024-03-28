#!/bin/bash

test_id="SEC-MOTD-CONFIGURED-PROPERLY-001"
test_name="Ensure message of the day is configured properly"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Pobranie identyfikatora dystrybucji z /etc/os-release
os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')

# Sprawdzenie, czy /etc/motd nie zawiera potencjalnie wrażliwych informacji
if grep -Eis "(\\\v|\\\r|\\\m|\\\s|$os_id)" /etc/motd &> /dev/null; then
    test_fail_messages+=(" - Plik /etc/motd może zawierać informacje o systemie.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;${test_fail_messages[*]}"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
