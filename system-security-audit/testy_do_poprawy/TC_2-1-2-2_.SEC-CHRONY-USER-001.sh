#!/bin/bash

test_id="SEC-CHRONY-USER-001"
test_name="Ensure chrony is running as user _chrony"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy 'chrony' jest zainstalowany
if ! command -v chronyc &> /dev/null; then
    echo "N/A;$test_id;$test_name; - 'chrony' nie jest zainstalowany."
    exit 0
fi

# Sprawdzenie, czy proces 'chronyd' działa jako użytkownik '_chrony'
if ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print }'; then
    test_fail_messages+=("Proces 'chronyd' nie jest uruchomiony jako użytkownik '_chrony'.")
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
