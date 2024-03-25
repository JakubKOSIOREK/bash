#!/bin/bash

test_id="SEC-APPORT-NOT-ENABLED-001"
test_name="Ensure Automatic Error Reporting (Apport) is not enabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy Apport jest zainstalowany
if dpkg-query -s apport &> /dev/null; then
    # Sprawdzenie, czy Apport jest włączony w /etc/default/apport
    if grep -Psi -- '^\h*enabled\h*=\h*[^0]\b' /etc/default/apport &> /dev/null; then
        test_fail_messages+=(" - Usługa Apport jest włączona w /etc/default/apport.")
        exit_status=1
    fi

    # Sprawdzenie, czy usługa Apport jest aktywna
    if systemctl is-active apport.service | grep '^active' &> /dev/null; then
        test_fail_messages+=(" - Usługa Apport jest aktywna.")
        exit_status=1
    fi
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
