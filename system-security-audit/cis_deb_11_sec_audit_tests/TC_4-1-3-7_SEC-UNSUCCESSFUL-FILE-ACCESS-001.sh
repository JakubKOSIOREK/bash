#!/usr/bin/env bash

test_id="SEC-UNSUCCESSFUL-FILE-ACCESS-001"
test_name="Ensure unsuccessful file access attempts are collected"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditctl &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
else
    # Załadowanie reguł do zmiennej
    loaded_rules=$(sudo /usr/sbin/auditctl -l)

    # Sprawdzanie obecności oczekiwanych reguł
    syscalls="open|truncate|ftruncate|creat|openat"
    conditions="-F exit=-EACCES -F auid>=1000 -F auid!=-1 -F key=access|-F exit=-EPERM -F auid>=1000 -F auid!=-1 -F key=access"
    archs="b64|b32"

    for arch in $archs; do
        for condition in $conditions; do
            if ! echo "$loaded_rules" | grep -Eq -e "-a always,exit -F arch=$arch -S .*($syscalls).* ($condition)"; then
                test_fail_messages+=("Oczekiwana reguła audytu dla arch=$arch z warunkami $condition nie jest załadowana")
                exit_status=1
            fi
        done
    done
fi

# Połączenie komunikatów o błędach w jedną linię
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
