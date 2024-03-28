#!/usr/bin/env bash

test_id="SEC-AUDIT-BACKLOG-LIMIT-SUFFICIENT-002"
test_name="Ensure audit_backlog_limit is sufficient"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Wyszukiwanie konfiguracji GRUB2 dla wierszy 'linux', które nie zawierają 'audit_backlog_limit' z wartością liczbową
audit_backlog_limit_missing=$(find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\s*linux' {} + | grep -Pv 'audit_backlog_limit=\d+\b')

if [[ -n "$audit_backlog_limit_missing" ]]; then
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    echo "FAIL;$test_id;$test_name; - Nie znaleziono odpowiedniej wartości 'audit_backlog_limit' w konfiguracji GRUB2 dla wierszy 'linux'."
fi

exit $exit_status
