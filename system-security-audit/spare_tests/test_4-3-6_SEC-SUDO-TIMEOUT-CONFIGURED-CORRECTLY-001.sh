#!/usr/bin/env bash

test_id="SEC-SUDO-TIMEOUT-CONFIGURED-CORRECTLY-001"
test_name="Ensure sudo authentication timeout is configured correctly"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie ustawienia timestamp_timeout w plikach sudoers
timeout_entries=$(grep -roP "Defaults\s+timestamp_timeout=\K-?[0-9]+" /etc/sudoers /etc/sudoers.d)

# Jeśli nie ma ustawienia timestamp_timeout, uznajemy domyślną wartość 15 minut za prawidłową
if [[ -z "$timeout_entries" ]]; then
    exit_status=0
else
    for entry in $timeout_entries; do
        if [[ "$entry" -gt 15 ]] || [[ "$entry" -eq -1 ]]; then
            test_fail_messages+=(" - Znaleziono ustawienie timestamp_timeout z wartością $entry, która jest nieprawidłowa.")
            exit_status=1
        fi
    done
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
