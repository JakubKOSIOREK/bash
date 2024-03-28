#!/usr/bin/env bash

test_id="SEC-CRON-ACCESS-RESTRICTED-001"
test_name="Ensure cron is restricted to authorized users"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy cron jest zainstalowany
if dpkg-query -W cron &>/dev/null; then
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
        file_info=$(stat -Lc '%A %U %G' /etc/cron.allow)
        read -r perms user group <<< "$file_info"

        # Sprawdzenie uprawnień
        if [[ $perms != -*r-------- ]]; then
            test_fail_messages+=(" - /etc/cron.allow ma niewłaściwe uprawnienia: $perms.")
            exit_status=1
        fi

        # Sprawdzenie właściciela
        if [ "$user" != "root" ]; then
            test_fail_messages+=(" - /etc/cron.allow ma niewłaściwego właściciela: $user.")
            exit_status=1
        fi

        # Sprawdzenie grupy
        if [ "$group" != "crontab" ]; then
            test_fail_messages+=(" - /etc/cron.allow ma niewłaściwą grupę: $group.")
            exit_status=1
        fi
    fi
else
    echo "N/A;$test_id;$test_name; - cron nie jest zainstalowany na systemie."
    exit 0
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
