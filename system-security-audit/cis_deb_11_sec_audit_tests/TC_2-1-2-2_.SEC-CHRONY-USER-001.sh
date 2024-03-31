#!/bin/bash

test_id="SEC-CHRONY-USER-001"
test_name="Ensure chrony is running as user _chrony"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy 'chrony' jest zainstalowany
if ! command -v chronyc &> /dev/null; then
    echo "N/A ;${test_id};${test_file};${test_name};'chrony' nie jest zainstalowany."
    exit 0
fi

# Sprawdzenie, czy proces 'chronyd' działa jako użytkownik '_chrony'
if ps -ef | grep '[c]hronyd' | grep -vq '^_chrony'; then
    test_fail_messages+=("Proces 'chronyd' nie jest uruchomiony jako użytkownik '_chrony'.")
    exit_status=1
fi

# Raportowanie wyniku tylko jeśli test się nie powiódł
if [ $exit_status -ne 0 ]; then
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
