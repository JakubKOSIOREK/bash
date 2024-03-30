#!/usr/bin/env bash

test_id="SEC-PRIV-COMMANDS-COLLECTED-001"
test_name="Ensure use of privileged commands are collected"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

privileged_cmds=(
    "/usr/bin/sudo"
    "/usr/bin/su"
    "/usr/bin/passwd"
    "/usr/bin/chsh"
    "/usr/bin/newgrp"
    "/usr/bin/chfn"
)

privileged_cmds_count=0
privileged_cmds_not_audited_count=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditctl &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
fi

# Załadowanie reguł do zmiennej
loaded_rules=$(sudo /usr/sbin/auditctl -l)

# Iteracja przez uprzywilejowane polecenia i sprawdzanie ich obecności w załadowanych regułach
for cmd in "${privileged_cmds[@]}"; do
    expected_rule="-S all -F path=${cmd} -F perm=x -F auid>=1000 -F auid!=-1 -F key=privileged"
    if echo "$loaded_rules" | grep -qE -- "$expected_rule"; then
        ((privileged_cmds_count++))
    else
        test_fail_messages+=("Brak reguły audytu dla: ${cmd}")
        ((privileged_cmds_not_audited_count++))
    fi
done

# Połączenie komunikatów w jedną linię
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Sprawdzanie, czy wszystkie uprzywilejowane polecenia są objęte regułami audytu
if [ "$privileged_cmds_not_audited_count" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
    exit_status=1
fi

exit $exit_status
