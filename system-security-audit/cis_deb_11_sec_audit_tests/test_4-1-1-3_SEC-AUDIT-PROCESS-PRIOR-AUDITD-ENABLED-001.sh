#!/usr/bin/env bash

test_id="SEC-AUDIT-PROCESS-PRIOR-AUDITD-ENABLED-001"
test_name="Ensure auditing for processes that start prior to auditd is enabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Wyszukiwanie konfiguracji GRUB2 dla wierszy 'linux', które nie zawierają 'audit=1'
if find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\s*linux' {} + | grep -qv 'audit=1'; then
    test_fail_messages+=(" - Nie znaleziono 'audit=1' w konfiguracji GRUB2 dla wierszy 'linux'.")
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
