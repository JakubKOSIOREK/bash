#!/usr/bin/env bash

test_id="SEC-AUDIT-LOG-SIZE-CONFIGURED-001"
test_name="Ensure audit log storage size is configured"
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditd &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Usługa auditd nie jest zainstalowana."
    exit 1
fi

# Wyszukiwanie konfiguracji 'max_log_file' w pliku auditd.conf
max_log_file_configured=$(grep -Po -- '^\s*max_log_file\s*=\s*\d+\b' /etc/audit/auditd.conf)

if [[ -z "$max_log_file_configured" ]]; then
    echo "FAIL;$test_id;$test_name; - Parametr 'max_log_file' nie jest skonfigurowany w /etc/audit/auditd.conf."
    exit_status=1
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
