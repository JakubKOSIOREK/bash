#!/bin/bash

test_id="SEC-RSYSLOG-INSTALLED-001"
test_name="Ensure rsyslog is installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Komunikaty o błędach

exit_status=0

# Sprawdzenie, czy pakiet rsyslog jest zainstalowany
if ! dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rsyslog | grep -q "install ok installed"; then
    test_fail_messages+=("Pakiet rsyslog nie jest zainstalowany.")
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
