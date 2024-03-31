#!/usr/bin/env bash

test_id="SEC-DCCP-DISABLED-001"
test_name="Ensure DCCP is disabled"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

module_name="dccp" # Nazwa modułu

# Sprawdzenie, czy moduł jest aktualnie załadowany
if lsmod | grep -q $module_name; then
    test_fail_messages+=("Moduł $module_name jest załadowany.")
    exit_status=1
else
    # Sprawdzenie, czy katalog /etc/modprobe.d/ istnieje i zawiera pliki
    if [ -d "/etc/modprobe.d/" ] && [ "$(ls -A /etc/modprobe.d/)" ]; then
        # Sprawdzenie, czy moduł jest zablokowany
        if ! grep -q "^blacklist $module_name" /etc/modprobe.d/* 2>/dev/null; then
            test_fail_messages+=("Moduł $module_name nie jest zablokowany w /etc/modprobe.d/.")
            exit_status=1
        fi
    else
        test_fail_messages+=("Katalog /etc/modprobe.d/ nie istnieje lub jest pusty.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
