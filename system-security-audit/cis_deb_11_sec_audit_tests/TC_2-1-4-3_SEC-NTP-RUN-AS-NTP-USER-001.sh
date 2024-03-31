#!/bin/bash

test_id="SEC-NTP-RUN-AS-NTP-USER-001"
test_name="Ensure ntp is running as user ntp"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy ntp jest używany na systemie
if ! systemctl is-enabled ntp &> /dev/null && ! systemctl is-enabled ntpd &> /dev/null; then
    echo "N/A;${test_id};${test_name};'ntp/ntpd' nie jest włączony."
    exit 0
fi

# Weryfikacja, czy proces ntpd działa jako użytkownik ntp
if ps -ef | awk '(/[n]tpd/ && $1!="ntp") { print $1 }'; then
    test_fail_messages+=("Proces ntpd nie jest uruchomiony jako użytkownik 'ntp'.")
    exit_status=1
fi

# Weryfikacja, czy w skrypcie startowym /etc/init.d/ntp RUNASUSER jest ustawione na ntp
if [ -f /etc/init.d/ntp ]; then
    runasuser=$(grep -Po '^\s*RUNASUSER=\Kntp' /etc/init.d/ntp)
    if [ "$runasuser" != "ntp" ]; then
        test_fail_messages+=("RUNASUSER w /etc/init.d/ntp nie jest ustawione na 'ntp'.")
        exit_status=1
    fi
else
    test_fail_messages+=("/etc/init.d/ntp nie istnieje.")
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
