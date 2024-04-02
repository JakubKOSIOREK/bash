#!/bin/bash

test_id="SEC-JOURNALD-SERVICE-ENABLED-001"
test_name="Ensure journald service is enabled"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Komunikaty o błędach

exit_status=0

# Sprawdzenie, czy usługa systemd-journald jest włączona
if ! systemctl is-enabled systemd-journald.service | grep -q "static"; then
    test_fail_messages+=("Usługa systemd-journald nie jest włączona.")
    exit_status=1
fi

# Połączenie komunikatów o błędach w jedną linię
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
