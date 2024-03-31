#!/bin/bash

test_id="SEC-NTP-ENABLED-RUNNING-001"
test_name="Ensure ntp is enabled and running"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy ntp jest używany na systemie
if ! systemctl is-enabled ntp &> /dev/null && ! systemctl is-enabled ntpd &> /dev/null; then
    echo "N/A;${test_id};${test_name}; - 'ntp/ntpd' nie jest włączony."
    exit 0
fi

# Sprawdzenie, czy usługa ntp jest włączona
if ! systemctl is-enabled ntp.service &> /dev/null; then
    test_fail_messages+=("'ntp.service' nie jest włączony.")
    exit_status=1
fi

# Sprawdzenie, czy usługa ntp jest aktywna
if ! systemctl is-active ntp.service &> /dev/null; then
    test_fail_messages+=("'ntp.service' nie jest aktywny.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
