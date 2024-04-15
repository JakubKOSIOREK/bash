#!/usr/bin/env bash

test_id="SEC-AUDIT-CHACL-COMMAND-USE-RECORDED-001"
test_name="Ensure successful and unsuccessful attempts to use the chacl command are recorded"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy narzędzie auditctl jest dostępne
if ! command -v auditctl &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
else
    # Załadowanie reguł do zmiennej
    loaded_rules=$(sudo /usr/sbin/auditctl -l)

    # Definicja oczekiwanej reguły
    declare -a expected_rules=(
        "-a always,exit -S all -F path=/usr/bin/chacl -F perm=x -F auid>=1000 -F auid!=-1 -F key=priv_cmd"
    )

    # Sprawdzanie obecności oczekiwanych reguł
    for rule in "${expected_rules[@]}"; do
        if ! echo "$loaded_rules" | grep -Fxq -- "$rule"; then
            test_fail_messages+=("Oczekiwana reguła audytu nie jest załadowana: $rule")
            exit_status=1
        fi
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
