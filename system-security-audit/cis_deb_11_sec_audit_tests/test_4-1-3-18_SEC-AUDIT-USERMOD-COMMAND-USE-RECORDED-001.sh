#!/usr/bin/env bash

test_id="SEC-AUDIT-USERMOD-COMMAND-USE-RECORDED-001"
test_name="Ensure successful and unsuccessful attempts to use the usermod command are recorded"
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

# Definicja oczekiwanej reguły audytu dla polecenia usermod
expected_rule="-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=${UID_MIN} -F auid!=-1 -k usermod"

# Sprawdzanie reguł na dysku
if ! grep -Pq -- "$(echo $expected_rule | sed 's/[\&\/]/\\&/g')" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "FAIL;$test_id;$test_name; - Brak oczekiwanej reguły audytu dla polecenia usermod."
    exit_status=1
fi

# Sprawdzanie załadowanych reguł
if ! auditctl -l | grep -Pq -- "$(echo $expected_rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
    echo "FAIL;$test_id;$test_name; - Oczekiwana reguła dla polecenia usermod nie jest załadowana."
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
