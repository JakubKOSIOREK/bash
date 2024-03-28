#!/usr/bin/env bash

test_id="SEC-AUDIT-MOUNTS-COLLECTED-001"
test_name="Ensure successful file system mounts are collected"
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

# Definicja oczekiwanych reguł audytu dla montowania systemów plików
expected_rules=(
    "-a always,exit -F arch=b64 -S mount -F auid>=${UID_MIN} -F auid!=-1 -k mounts"
    "-a always,exit -F arch=b32 -S mount -F auid>=${UID_MIN} -F auid!=-1 -k mounts"
)

# Sprawdzanie reguł na dysku
for rule in "${expected_rules[@]}"; do
    if ! grep -Pq -- "$(echo $rule | sed 's/[\&\/]/\\&/g')" /etc/audit/rules.d/*.rules 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Brak oczekiwanej reguły audytu dla montowania: $rule."
        exit_status=1
    fi
done

# Sprawdzanie załadowanych reguł
for rule in "${expected_rules[@]}"; do
    if ! auditctl -l | grep -Pq -- "$(echo $rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Oczekiwana reguła dla montowania nie jest załadowana: $rule."
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
