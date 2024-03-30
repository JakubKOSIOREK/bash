#!/usr/bin/env bash

test_id="SEC-AUDIT-MOUNTS-COLLECTED-001"
test_name="Ensure successful file system mounts are collected"
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

    # Definicja oczekiwanych reguł audytu dla montowania systemów plików
    expected_rules=(
        "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=-1 -F key=mounts"
        "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=-1 -F key=mounts"
    )

    # Sprawdzanie obecności oczekiwanych reguł
    for rule in "${expected_rules[@]}"; do
        if ! echo "$loaded_rules" | grep -Pq -- "$(echo $rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
            test_fail_messages+=("Brak oczekiwanej reguły audytu dla montowania: $rule")
            exit_status=1
        fi
    done
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
