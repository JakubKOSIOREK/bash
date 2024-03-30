#!/usr/bin/env bash

test_id="SEC-AUDIT-LOGIN-LOGOUT-EVENTS-COLLECTED-001"
test_name="Ensure login and logout events are collected"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy narzędzie auditctl jest dostępne
if ! command -v auditctl &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
fi

# Lista plików i katalogów do monitorowania
files_to_monitor=(
    "/var/log/lastlog"
    "/var/run/faillock"
)

# Załadowanie reguł do zmiennej
loaded_rules=$(sudo auditctl -l)

# Sprawdzanie obecności oczekiwanych reguł dla każdego pliku/katalogu
for file in "${files_to_monitor[@]}"; do
    expected_rule="-w ${file} -p wa -k logins"
    if ! echo "$loaded_rules" | grep -qE -- "$expected_rule"; then
        test_fail_messages+=("Brak reguły audytu dla: ${file}")
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
