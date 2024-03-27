#!/bin/bash

test_id="SEC-CRON-ENABLED-ACTIVE-001"
test_name="Ensure cron daemon is enabled and active"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy cron jest włączony
cron_enabled=$(systemctl is-enabled cron)
if [ "$cron_enabled" != "enabled" ]; then
    test_fail_messages+=(" - Daemon cron nie jest włączony.")
    exit_status=1
fi

# Sprawdzenie, czy cron jest aktywny
cron_active=$(systemctl is-active cron)
if [ "$cron_active" != "active" ]; then
    test_fail_messages+=(" - Daemon cron nie jest aktywny.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
