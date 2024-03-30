#!/bin/bash

test_id="SEC-CHRONY-ENABLED-RUNNING-001"
test_name="Ensure chrony is enabled and running"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy 'chrony' jest zainstalowany
if ! command -v chronyc &> /dev/null; then
    echo "N/A;$test_id;$test_name; - 'chrony' nie jest zainstalowany."
    exit 0
fi

# Sprawdzenie, czy usługa 'chrony' jest włączona
if systemctl is-enabled chrony.service &> /dev/null; then
    echo "'chrony.service' jest włączony."
else
    test_fail_messages+=("'chrony.service' nie jest włączony.")
    exit_status=1
fi

# Sprawdzenie, czy usługa 'chrony' jest aktywna
if systemctl is-active chrony.service &> /dev/null; then
    echo "'chrony.service' działa."
else
    test_fail_messages+=("'chrony.service' nie jest aktywny.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
