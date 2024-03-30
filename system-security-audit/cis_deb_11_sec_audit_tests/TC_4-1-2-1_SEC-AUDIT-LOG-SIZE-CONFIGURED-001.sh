#!/usr/bin/env bash

test_id="SEC-AUDIT-LOG-SIZE-CONFIGURED-001"
test_name="Ensure audit log storage size is configured"
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
    # Wyszukiwanie konfiguracji 'max_log_file' w pliku auditd.conf
    max_log_file_configured=$(grep -Po -- '^\s*max_log_file\s*=\s*\d+\b' /etc/audit/auditd.conf)
    if [[ -z "$max_log_file_configured" ]]; then
        test_fail_messages+=("Parametr 'max_log_file' nie jest skonfigurowany w /etc/audit/auditd.conf.")
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
