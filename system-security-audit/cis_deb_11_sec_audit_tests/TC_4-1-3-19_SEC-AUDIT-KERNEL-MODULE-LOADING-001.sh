#!/usr/bin/env bash

test_id="SEC-AUDIT-KERNEL-MODULE-LOADING-001"
test_name="Ensure kernel module loading, unloading, and modification is collected"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy narzędzie auditctl jest dostępne
if ! command -v auditctl &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
else
    loaded_rules=$(sudo auditctl -l)

    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "${UID_MIN}" ]; then
        test_fail_messages+=("Nie można ustalić UID_MIN z /etc/login.defs.")
        exit_status=1
    else
        # Sprawdzanie obecności reguły dla syscalli związanych z modułami jądra
        if ! echo "$loaded_rules" | grep -Pq -- "-F arch=b64 -S .*create_module.*init_module.*delete_module.*query_module.*finit_module.* -F auid>=${UID_MIN} -F auid!=-1 -F key=kernel_modules"; then
            test_fail_messages+=("Brak oczekiwanej reguły audytu dla syscalli modułów jądra.")
            exit_status=1
        fi

        # Sprawdzanie obecności reguły dla ścieżki /usr/bin/kmod
        if ! echo "$loaded_rules" | grep -Pq -- "-S all -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=-1 -F key=kernel_modules"; then
            test_fail_messages+=("Brak oczekiwanej reguły audytu dla /usr/bin/kmod.")
            exit_status=1
        fi
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=$';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
