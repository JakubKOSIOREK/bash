#!/usr/bin/env bash

test_id="SEC-SUDO-INSTALLED-001"
test_name="Ensure sudo is installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie instalacji sudo lub sudo-ldap dla różnych menadżerów pakietów
if command -v dpkg &>/dev/null; then
    if ! dpkg-query -W sudo sudo-ldap &>/dev/null; then
        test_fail_messages+=("Ani pakiet sudo, ani sudo-ldap nie są zainstalowane.")
        exit_status=1
    fi
elif command -v rpm &>/dev/null; then
    if ! rpm -q sudo sudo-ldap &>/dev/null; then
        test_fail_messages+=("Ani pakiet sudo, ani sudo-ldap nie są zainstalowane.")
        exit_status=1
    fi
else
    test_fail_messages+=("Nie znaleziono menadżera pakietów dpkg ani rpm.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
