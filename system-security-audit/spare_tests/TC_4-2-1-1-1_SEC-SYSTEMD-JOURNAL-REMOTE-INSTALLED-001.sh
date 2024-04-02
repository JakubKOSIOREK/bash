#!/bin/bash

test_id="SEC-SYSTEMD-JOURNAL-REMOTE-INSTALLED-001"
test_name="Ensure systemd-journal-remote is installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Komunikaty o błędach

exit_status=0

# Sprawdzenie, czy systemd-journal-remote jest zainstalowany
if ! dpkg-query -W systemd-journal-remote &>/dev/null; then
    test_fail_messages+=("systemd-journal-remote nie jest zainstalowany.")
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
