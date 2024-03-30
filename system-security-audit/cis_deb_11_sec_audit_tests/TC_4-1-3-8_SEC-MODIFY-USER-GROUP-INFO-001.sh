#!/usr/bin/env bash

test_id="SEC-MODIFY-USER-GROUP-INFO-001"
test_name="Ensure events that modify user/group information are collected"
exit_status=0
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

# Sprawdzenie istnienia narzędzia auditctl
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest dostępne."
    exit 1
fi

# Lista plików do monitorowania
files_to_monitor=(
    "/etc/group"
    "/etc/passwd"
    "/etc/gshadow"
    "/etc/shadow"
    "/etc/security/opasswd"
)

# Załadowanie reguł do zmiennej
loaded_rules=$(sudo auditctl -l)

# Sprawdzanie obecności oczekiwanych reguł dla każdego pliku
for file in "${files_to_monitor[@]}"; do
    expected_rule="-w ${file} -p wa -k identity"
    if ! echo "$loaded_rules" | grep -qE -- "$expected_rule"; then
        test_fail_messages+=("Brak reguły audytu dla: ${file}")
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name}"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
