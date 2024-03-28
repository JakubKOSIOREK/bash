#!/usr/bin/env bash

test_id="SEC-AUDIT-CONFIG-IMMUTABLE-001"
test_name="Ensure the audit configuration is immutable"
exit_status=0

# Sprawdzenie, czy w katalogu /etc/audit/rules.d/ istnieją jakiekolwiek pliki z regułami
if ls /etc/audit/rules.d/*.rules 1> /dev/null 2>&1; then
    # Sprawdzenie, czy konfiguracja audytu zawiera '-e 2'
    if grep -Ph -- '^\s*-e\s+2\b' /etc/audit/rules.d/*.rules | tail -1 | grep -q '\-e 2'; then
        echo "PASS;$test_id;$test_name;"
    else
        echo "FAIL;$test_id;$test_name; - Konfiguracja audytu nie jest ustawiona na niemodyfikowalną."
        exit_status=1
    fi
else
    echo "FAIL;$test_id;$test_name; - Brak plików reguł w /etc/audit/rules.d/."
    exit_status=1
fi

# Raportowanie wyniku
exit $exit_status
