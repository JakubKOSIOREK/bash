#!/usr/bin/env bash

test_id="SEC-CRON-ACCESS-RESTRICTED-001"
test_name="Ensure cron is restricted to authorized users"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy cron jest zainstalowany
if ! dpkg-query -W cron &>/dev/null; then
    echo "N/A;$test_id;$test_name; - cron nie jest zainstalowany na systemie."
    exit 0
fi

# Sprawdzenie, czy /etc/cron.deny nie istnieje
if [ -e /etc/cron.deny ]; then
    test_fail_messages+=(" - /etc/cron.deny istnieje.")
    exit_status=1
fi

# Sprawdzenie, czy /etc/cron.allow istnieje
if [ ! -e /etc/cron.allow ]; then
    test_fail_messages+=(" - /etc/cron.allow nie istnieje.")
    exit_status=1
else
    # Pobranie informacji o pliku
    perms_numeric=$(stat -c '%a' /etc/cron.allow)
    owner=$(stat -c '%U' /etc/cron.allow)
    group=$(stat -c '%G' /etc/cron.allow)

    # Sprawdzenie uprawnień (oczekiwane 640 lub bardziej restrykcyjne)
    if [ "$perms_numeric" -gt 640 ]; then
        test_fail_messages+=(" - /etc/cron.allow ma niewłaściwe uprawnienia: $perms_numeric.")
        exit_status=1
    fi

    # Sprawdzenie właściciela
    if [ "$owner" != "root" ]; then
        test_fail_messages+=(" - /etc/cron.allow ma niewłaściwego właściciela: $owner.")
        exit_status=1
    fi

    # Sprawdzenie grupy
    if [ "$group" != "root" ]; then
        test_fail_messages+=(" - /etc/cron.allow ma niewłaściwą grupę: $group.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
