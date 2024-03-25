#!/bin/bash

test_id="SEC-GDM-LOCKDOWN-SCREEN-LOCK-001"
test_name="Ensure GDM screen locks cannot be overridden"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0
lockdown_directory="/etc/dconf/db/local.d/locks"

# Sprawdzenie, czy GDM jest zainstalowany
if ! dpkg-query -W -f='${Status}' gdm 2>/dev/null | grep -q "install ok installed" && ! dpkg-query -W -f='${Status}' gdm3 2>/dev/null | grep -q "install ok installed"; then
    echo "PASS;$test_id;$test_name;"
    exit 0
fi

# Sprawdzenie, czy katalog blokad istnieje
if [ ! -d "$lockdown_directory" ]; then
    echo "FAIL;$test_id;$test_name; - Katalog blokad dconf ($lockdown_directory) nie istnieje."
    exit 1
fi

# Lista kluczy, które powinny być zablokowane
keys_to_lock=(
    "/org/gnome/desktop/session/idle-delay"
    "/org/gnome/desktop/screensaver/lock-delay"
)

# Sprawdzenie, czy wszystkie wymagane klucze są zablokowane
for key in "${keys_to_lock[@]}"; do
    if ! grep -q "^$key$" "$lockdown_directory"/*; then
        test_fail_messages+=("Klucz $key nie jest zablokowany.")
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;$(IFS='; '; echo "${test_fail_messages[*]}")"
else
    echo "PASS;$test_id;$test_name; - Wszystkie wymagane klucze dconf są zablokowane."
fi

exit $exit_status
