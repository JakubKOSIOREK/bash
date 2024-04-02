#!/bin/bash

test_id="SEC-CRON-ENABLED-ACTIVE-001"
test_name="Ensure cron daemon is enabled and active"
test_fail_messages=() # Tablica na komunikaty o błędach

script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy cron jest włączony
if ! systemctl is-enabled cron &> /dev/null; then
    test_fail_messages+=("cron is not enabled")
    exit_status=1
fi

# Sprawdzenie, czy cron jest aktywny (działa)
if ! systemctl status cron | grep -q 'Active: active (running)'; then
    test_fail_messages+=("cron is not running")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
