#!/usr/bin/env bash

test_id="SEC-AUDIT-FILE-DELETION-EVENTS-COLLECTED-001"
test_name="Ensure file deletion events by users are collected"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! sudo /usr/sbin/auditctl -l &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
else
    # Załadowanie reguł do zmiennej
    loaded_rules=$(sudo /usr/sbin/auditctl -l)

    # Definicja oczekiwanych wzorców dla reguł audytu związanych z usuwaniem plików
    expected_rules_patterns=(
        "-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=1000 -F auid!=-1 -F key=delete"
        "-a always,exit -F arch=b32 -S unlink,rename,unlinkat,renameat -F auid>=1000 -F auid!=-1 -F key=delete"
    )

    # Funkcja do sprawdzania obecności reguły
    check_rule() {
        local pattern="$1"
        echo "$loaded_rules" | grep -qP -- "$pattern" && return 0 || return 1
    }

    # Iteracja przez wzorce reguł i sprawdzanie ich obecności
    for pattern in "${expected_rules_patterns[@]}"; do
        if ! check_rule "$pattern"; then
            test_fail_messages+=("Oczekiwana reguła audytu nie jest załadowana: $pattern")
            exit_status=1
            break # Można usunąć 'break', aby zbierać wszystkie brakujące reguły
        fi
    done
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name}"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
