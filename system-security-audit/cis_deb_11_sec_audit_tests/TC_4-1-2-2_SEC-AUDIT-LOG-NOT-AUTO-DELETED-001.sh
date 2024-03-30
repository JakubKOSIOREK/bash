#!/usr/bin/env bash

test_id="SEC-AUDIT-LOG-NOT-AUTO-DELETED-001"
test_name="Ensure audit logs are not automatically deleted"
file_name="/etc/audit/auditd.conf"

script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditd &> /dev/null; then
    test_fail_messages+=("Usługa auditd nie jest zainstalowana.")
    exit_status=1
else
    # Sprawdzenie ustawienia 'max_log_file_action' w pliku auditd.conf
    if ! grep -Pq '^max_log_file_action\s*=\s*keep_logs\b' /etc/audit/auditd.conf; then
        test_fail_messages+=("Ustawienie 'max_log_file_action' nie jest skonfigurowane jako 'keep_logs'.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name}"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
