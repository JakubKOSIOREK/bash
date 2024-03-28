#!/usr/bin/env bash

test_id="SEC-AUDIT-DAC-MODS-001"
test_name="Ensure discretionary access control permission modification events are collected"
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

# Definicja oczekiwanych reguł audytu
expected_rules=(
    "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat,chown,fchown,lchown,fchownat,setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=-1 -k perm_mod"
    "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat,chown,fchown,lchown,fchownat,setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=-1 -k perm_mod"
)

# Sprawdzanie reguł na dysku
for rule in "${expected_rules[@]}"; do
    if ! grep -Pq -- "$(echo $rule | sed 's/[\&\/]/\\&/g')" /etc/audit/rules.d/*.rules 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Nie znaleziono oczekiwanej reguły audytu: $rule w konfiguracji na dysku."
        exit_status=1
    fi
done

# Sprawdzanie załadowanych reguł
for rule in "${expected_rules[@]}"; do
    if ! auditctl -l | grep -Pq -- "$(echo $rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Oczekiwana reguła audytu nie jest załadowana: $rule."
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
