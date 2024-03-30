#!/usr/bin/env bash

test_id="SEC-AUDIT-SETFACL-COMMAND-USE-RECORDED-001"
test_name="Ensure successful and unsuccessful attempts to use the setfacl command are recorded"
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
    loaded_rules=$(sudo auditctl -l)

    # Pobranie minimalnego UID użytkownika
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "${UID_MIN}" ]; then
        test_fail_messages+=("Nie można ustalić UID_MIN z /etc/login.defs.")
        exit_status=1
    else
        # Definicja oczekiwanej reguły audytu dla polecenia setfacl
        expected_rule="-S all -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=-1 -F key=perm_chng"

        # Sprawdzanie obecności oczekiwanej reguły
        if ! echo "$loaded_rules" | grep -Pq -- "$(echo $expected_rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
            test_fail_messages+=("Brak oczekiwanej reguły audytu dla polecenia setfacl.")
            exit_status=1
        fi
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
