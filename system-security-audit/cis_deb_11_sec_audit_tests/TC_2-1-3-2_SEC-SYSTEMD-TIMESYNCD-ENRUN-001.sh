#!/bin/bash

test_id="SEC-SYSTEMD-TIMESYNCD-ENRUN-001"
test_name="Ensure systemd-timesyncd is enabled and running"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzanie, czy systemd-timesyncd jest włączony
if ! systemctl is-enabled systemd-timesyncd.service &> /dev/null; then
    test_fail_messages+=("systemd-timesyncd nie jest włączony.")
    exit_status=1
fi

# Sprawdzanie, czy systemd-timesyncd jest aktywny
if ! systemctl is-active systemd-timesyncd.service &> /dev/null; then
    test_fail_messages+=("systemd-timesyncd nie jest aktywny.")
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
