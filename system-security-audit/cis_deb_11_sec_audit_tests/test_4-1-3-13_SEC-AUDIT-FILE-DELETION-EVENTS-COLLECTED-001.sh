#!/usr/bin/env bash

test_id="SEC-AUDIT-FILE-DELETION-EVENTS-COLLECTED-001"
test_name="Ensure file deletion events by users are collected"
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest dostępne."
    exit 1
fi

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

if [ -z "${UID_MIN}" ]; then
    echo "FAIL;$test_id;$test_name; - Nie można ustalić UID_MIN z /etc/login.defs."
    exit 1
fi

# Definicja oczekiwanych reguł audytu dla usuwania i zmiany nazwy plików
expected_rules=(
    "-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=${UID_MIN} -F auid!=-1 -k delete"
    "-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=${UID_MIN} -F auid!=-1 -k delete"
)

# Sprawdzanie reguł na dysku
for rule in "${expected_rules[@]}"; do
    if ! grep -Pq -- "$(echo $rule | sed 's/[\&\/]/\\&/g')" /etc/audit/rules.d/*.rules 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Brak oczekiwanej reguły audytu: $rule."
        exit_status=1
    fi
done

# Sprawdzanie załadowanych reguł
for rule in "${expected_rules[@]}"; do
    if ! auditctl -l | grep -Pq -- "$(echo $rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Oczekiwana reguła nie jest załadowana: $rule."
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
