#!/usr/bin/env bash

test_id="SEC-AUDIT-MAC-MODIFY-EVENTS-COLLECTED-001"
test_name="Ensure events that modify the system's Mandatory Access Controls are collected"
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
    loaded_rules=$(sudo auditctl -l)

    # Katalogi AppArmor do monitorowania
    directories_to_monitor=(
        "/etc/apparmor"
        "/etc/apparmor.d"
    )

    # Sprawdzanie obecności oczekiwanych reguł dla każdego katalogu
    for directory in "${directories_to_monitor[@]}"; do
        expected_rule="-w ${directory} -p wa -k MAC-policy"
        if ! echo "$loaded_rules" | grep -qE -- "$(echo $expected_rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
            test_fail_messages+=("Brak reguły audytu dla katalogu: ${directory}")
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
