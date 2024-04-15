#!/usr/bin/env bash

test_id="SEC-AUDIT-BACKLOG-LIMIT-SUFFICIENT-001"
test_name="Ensure audit_backlog_limit is sufficient"
file_name="/etc/default/grub"

script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie konfiguracji GRUB2 w 'GRUB_CMDLINE_LINUX' i 'GRUB_CMDLINE_LINUX_DEFAULT', które nie zawierają 'audit_backlog_limit' z wartością liczbową
if ! grep -Eq '^(GRUB_CMDLINE_LINUX|GRUB_CMDLINE_LINUX_DEFAULT)=".*audit_backlog_limit=[0-9]+.*"' "$file_name"; then
    test_fail_messages+=("Nie znaleziono odpowiedniej wartości 'audit_backlog_limit' w konfiguracji GRUB2.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name}"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
