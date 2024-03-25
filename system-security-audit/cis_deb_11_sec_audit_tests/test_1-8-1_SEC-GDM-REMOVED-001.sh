#!/bin/bash

test_id="SEC-GDM-REMOVED-001"
test_name="Ensure GNOME Display Manager is removed"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy gdm3 nie jest zainstalowany
if dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' gdm3 2>/dev/null | grep -q "install ok installed"; then
    test_fail_messages+=("Pakiet gdm3 jest zainstalowany.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;${test_fail_messages[*]}"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
