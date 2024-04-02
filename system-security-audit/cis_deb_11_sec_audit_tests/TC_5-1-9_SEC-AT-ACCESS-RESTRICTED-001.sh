#!/usr/bin/env bash

test_id="SEC-AT-ACCESS-RESTRICTED-001"
test_name="Ensure at is restricted to authorized users"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy usługa at jest zainstalowana
if dpkg-query -W at &>/dev/null; then
    # Sprawdzenie, czy /etc/at.deny nie istnieje
    if [ -e /etc/at.deny ]; then
        test_fail_messages+=(" - /etc/at.deny istnieje.")
        exit_status=1
    fi

    # Sprawdzenie, czy /etc/at.allow istnieje
    if [ ! -e /etc/at.allow ]; then
        test_fail_messages+=(" - /etc/at.allow nie istnieje.")
        exit_status=1
    else
        # Pobranie informacji o pliku
        file_info=$(stat -Lc '%A %U %G' /etc/at.allow)
        read -r perms user group <<< "$file_info"

        # Sprawdzenie uprawnień
        if [[ $perms != "600" ]]; then
            test_fail_messages+=(" - /etc/at.allow ma niewłaściwe uprawnienia: $perms.")
            exit_status=1
        fi

        # Sprawdzenie właściciela
        if [ "$user" != "root" ]; then
            test_fail_messages+=(" - /etc/at.allow ma niewłaściwego właściciela: $user.")
            exit_status=1
        fi

        # Sprawdzenie grupy
        if [ "$group" != "root" ]; then
            test_fail_messages+=(" - /etc/at.allow ma niewłaściwą grupę: $group.")
            exit_status=1
        fi
    fi
else
    echo "N/A ;$test_id;$test_file;$test_name;at nie jest zainstalowany na systemie."
    exit 0
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
