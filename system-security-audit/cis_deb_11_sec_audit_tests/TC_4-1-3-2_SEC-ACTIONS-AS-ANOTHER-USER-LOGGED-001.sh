#!/usr/bin/env bash

test_id="SEC-ACTIONS-AS-ANOTHER-USER-LOGGED-001"
test_name="Ensure actions as another user are always logged"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! command -v auditctl &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
else
    # Załadowanie reguł do zmiennej
    loaded_rules=$(auditctl -l)

    # Definicja oczekiwanych elementów reguł jako wzorców
    expected_rules_patterns=(
        "-a always,exit -F arch=b64 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation"
        "-a always,exit -F arch=b32 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation"
    )

    # Funkcja do sprawdzania obecności reguły
    check_rule() {
        local pattern="$1"
        echo "$loaded_rules" | grep -qE -- "$pattern" && return 0 || return 1
    }

    # Iteracja przez wzorce reguł i sprawdzanie ich obecności
    for pattern in "${expected_rules_patterns[@]}"; do
        if ! check_rule "$pattern"; then
            test_fail_messages+=("Oczekiwana reguła audytu nie jest załadowana: $pattern")
            exit_status=1
            break # Wyjście z pętli po pierwszym niepowodzeniu
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
