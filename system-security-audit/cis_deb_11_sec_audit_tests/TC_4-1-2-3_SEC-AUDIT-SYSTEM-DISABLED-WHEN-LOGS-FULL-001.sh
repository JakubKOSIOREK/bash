#!/usr/bin/env bash

test_id="SEC-AUDIT-SYSTEM-DISABLED-WHEN-LOGS-FULL-001"
test_name="Ensure system is disabled when audit logs are full"
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
    # Sprawdzenie konfiguracji 'space_left_action'
    if ! grep -Pq '^space_left_action\s*=\s*email\b' /etc/audit/auditd.conf; then
        test_fail_messages+=("Ustawienie 'space_left_action' nie jest skonfigurowane jako 'email'.")
        exit_status=1
    fi

    # Sprawdzenie konfiguracji 'action_mail_acct'
    if ! grep -Pq '^action_mail_acct\s*=\s*root\b' /etc/audit/auditd.conf; then
        test_fail_messages+=("Ustawienie 'action_mail_acct' nie wskazuje na 'root'.")
        exit_status=1
    fi

    # Sprawdzenie konfiguracji 'admin_space_left_action'
    if ! grep -Pq '^admin_space_left_action\s*=\s*(halt|single)\b' /etc/audit/auditd.conf; then
        test_fail_messages+=("Ustawienie 'admin_space_left_action' nie jest skonfigurowane jako 'halt' lub 'single'.")
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
