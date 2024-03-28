#!/usr/bin/env bash

test_id="SEC-AUDIT-LOG-NOT-AUTO-DELETED-001"
test_name="Ensure audit logs are not automatically deleted"
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditd &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Usługa auditd nie jest zainstalowana."
    exit 1
fi

# Sprawdzenie ustawienia 'max_log_file_action' w pliku auditd.conf
if grep -Pq '^max_log_file_action\s*=\s*keep_logs\b' /etc/audit/auditd.conf; then
    echo "PASS;$test_id;$test_name;"
else
    echo "FAIL;$test_id;$test_name; - Ustawienie 'max_log_file_action' nie jest skonfigurowane jako 'keep_logs'."
    exit_status=1
fi

exit $exit_status
