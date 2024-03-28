#!/usr/bin/env bash

test_id="SEC-AUDIT-KERNEL-MODULE-LOADING-001"
test_name="Ensure kernel module loading unloading and modification is collected"
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

# Definicje oczekiwanych reguł audytu
expected_rules=(
    "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=${UID_MIN} -F auid!=-1 -k kernel_modules"
    "-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=-1 -k kernel_modules"
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

# Dodatkowa weryfikacja symlinków
S_LINKS=$(ls -l /usr/sbin/lsmod /usr/sbin/rmmod /usr/sbin/insmod /usr/sbin/modinfo /usr/sbin/modprobe /usr/sbin/depmod | grep -v " -> ../bin/kmod" || true)
if [[ "${S_LINKS}" != "" ]]; then
    echo "FAIL;$test_id;$test_name; - Problem z symlinkami: ${S_LINKS}."
    exit_status=1
else
    echo "Symlinki do kmod są poprawne."
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
