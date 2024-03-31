#!/bin/bash

test_id="SEC-MTA-LOCAL-ONLY-001"
test_name="Ensure mail transfer agent is configured for local-only mode"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy MTA nie nasłuchuje na żadnych adresach zewnętrznych (nie-lokalnych)
if ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s' >/dev/null; then
    test_fail_messages+=("MTA nasłuchuje na adresach zewnętrznych, co nie jest zalecane.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
