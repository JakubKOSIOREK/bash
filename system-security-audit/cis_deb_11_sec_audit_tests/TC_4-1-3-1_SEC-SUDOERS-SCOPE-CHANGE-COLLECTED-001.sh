#!/usr/bin/env bash

test_id="SEC-SUDOERS-SCOPE-CHANGE-COLLECTED-002"
test_name="Ensure changes to system administration scope (sudoers) are collected"
file_name="/etc/audit/audit.rules"

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

    # Definicja oczekiwanych elementów reguł jako wzorców
    expected_rules_patterns=(
        "-w /etc/sudoers -p wa -k scope"
        "-w /etc/sudoers.d -p wa -k scope"
    )

    # Funkcja do sprawdzania obecności reguły
    check_rule() {
        local pattern="$1"
        echo "$loaded_rules" | grep -q -- "$pattern"
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
