#!/usr/bin/env bash

test_id="SEC-SERVICE-ENABLED-ACTIVE-002"
service_name="auditd"
test_name="Ensure $service_name service is enabled and active"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy usługa istnieje
if ! systemctl list-unit-files | grep -qw "$service_name.service"; then
    echo "Usługa $service_name nie istnieje."
    test_fail_messages+=(" - Usługa $service_name nie istnieje na tym systemie.")
    exit_status=1
else
    # Sprawdzenie, czy usługa jest włączona
    if systemctl is-enabled $service_name | grep -qv "enabled"; then
        test_fail_messages+=(" - Usługa $service_name nie jest włączona.")
        exit_status=1
    fi

    # Sprawdzenie, czy usługa jest aktywna
    if systemctl is-active $service_name | grep -qv "active"; then
        test_fail_messages+=(" - Usługa $service_name nie jest aktywna.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status