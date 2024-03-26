#!/usr/bin/env bash

test_id="SEC-RDS-DISABLED-001"
test_name="Ensure RDS is disabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

module_name="rds" # Nazwa modułu

# Sprawdzenie, czy moduł jest aktualnie załadowany
if lsmod | grep -q $module_name; then
    test_fail_messages+=("Moduł $module_name jest załadowany.")
    exit_status=1
else
    # Sprawdzenie, czy katalog /etc/modprobe.d/ istnieje i zawiera pliki
    if [ -d "/etc/modprobe.d/" ] && [ "$(ls -A /etc/modprobe.d/)" ]; then
        # Sprawdzenie, czy moduł jest zablokowany
        if ! grep -q "^blacklist $module_name" /etc/modprobe.d/* 2>/dev/null; then
            exit_status=0
        fi
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
