#!/bin/bash

test_id="SEC-GDM-REMOVED-001"
test_name="Ensure GNOME Display Manager is removed"
test_fail_messages=() # Tablica na komunikaty o błędach

script_path="$0"
test_file=$(basename "$script_path")

exit_status=0

# Sprawdzenie, czy gdm3 nie jest zainstalowany
if dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' gdm3 2>/dev/null | grep -q "install ok installed"; then
    test_fail_messages+=("Pakiet gdm3 jest zainstalowany.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
