#!/usr/bin/env bash

test_id="SEC-AUDIT-CONFIG-IMMUTABLE-001"
test_name="Ensure the audit configuration is immutable"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy w katalogu /etc/audit/rules.d/ istnieją jakiekolwiek pliki z regułami
if ls /etc/audit/rules.d/*.rules 1> /dev/null 2>&1; then
    # Sprawdzenie, czy konfiguracja audytu zawiera '-e 2'
    if ! grep -Ph -- '^\s*-e\s+2\b' /etc/audit/rules.d/*.rules | tail -1 | grep -q '\-e 2'; then
        test_fail_messages+=("Konfiguracja audytu nie jest ustawiona na niemodyfikowalną (-e 2).")
        exit_status=1
    fi
else
    test_fail_messages+=("Brak plików reguł w /etc/audit/rules.d/.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=$'\n'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
