#!/usr/bin/env bash

test_id="SEC-AUDITD-INSTALLED-001"
test_name="Ensure auditd is installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy pakiet auditd jest zainstalowany
if ! dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' auditd &>/dev/null; then
    test_fail_messages+=("Pakiet auditd nie jest zainstalowany.")
    exit_status=1
fi

# Sprawdzenie, czy pakiet audispd-plugins jest zainstalowany
if ! dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' audispd-plugins &>/dev/null; then
    test_fail_messages+=("Pakiet audispd-plugins nie jest zainstalowany.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
