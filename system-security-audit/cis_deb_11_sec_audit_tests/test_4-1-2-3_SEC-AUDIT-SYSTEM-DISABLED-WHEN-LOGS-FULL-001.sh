#!/usr/bin/env bash

test_id="SEC-AUDIT-SYSTEM-DISABLED-WHEN-LOGS-FULL-001"
test_name="Ensure system is disabled when audit logs are full"
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditd &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Usługa auditd nie jest zainstalowana."
    exit 1
fi

# Sprawdzenie konfiguracji 'space_left_action' i 'action_mail_acct'
if ! grep -Pq '^space_left_action\s*=\s*email\b' /etc/audit/auditd.conf; then
    echo "FAIL;$test_id;$test_name; - Ustawienie 'space_left_action' nie jest skonfigurowane jako 'email'."
    exit_status=1
fi

if ! grep -Pq '^action_mail_acct\s*=\s*root\b' /etc/audit/auditd.conf; then
    echo "FAIL;$test_id;$test_name; - Ustawienie 'action_mail_acct' nie wskazuje na 'root'."
    exit_status=1
fi

# Sprawdzenie konfiguracji 'admin_space_left_action'
if grep -Pq '^admin_space_left_action\s*=\s*(halt|single)\b' /etc/audit/auditd.conf; then
    echo "PASS;$test_id;$test_name; - Ustawienie 'admin_space_left_action' jest skonfigurowane jako 'halt' lub 'single'."
else
    echo "FAIL;$test_id;$test_name; - Ustawienie 'admin_space_left_action' nie jest skonfigurowane jako 'halt' lub 'single'."
    exit_status=1
fi

exit $exit_status
