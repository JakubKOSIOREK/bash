#!/bin/bash

test_id="SEC-GDM-AUTOMOUNT-LOCKDOWN-001"
test_name="Ensure GDM disabling automatic mounting of removable media is not overridden"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Definiowanie ścieżki do katalogu z plikami blokad dconf
locks_directory="/etc/dconf/db/local.d/locks"

# Sprawdzenie, czy GDM jest zainstalowany
if ! dpkg-query -W -f='${Status}' gdm 2>/dev/null | grep -q "install ok installed" && ! dpkg-query -W -f='${Status}' gdm3 2>/dev/null | grep -q "install ok installed"; then
    echo "PASS;$test_id;$test_name;"
    exit 0
fi

# Lista kluczy dconf, które powinny być zablokowane
keys_to_lock=(
    "/org/gnome/desktop/media-handling/automount"
    "/org/gnome/desktop/media-handling/automount-open"
)

# Sprawdzenie, czy katalog z blokadami istnieje
if [ ! -d "$locks_directory" ]; then
    echo "FAIL;$test_id;$test_name; - Katalog z blokadami dconf ($locks_directory) nie istnieje."
    exit 1
fi

# Sprawdzenie, czy wszystkie wymagane klucze są zablokowane
for key in "${keys_to_lock[@]}"; do
    lock_file_path="$locks_directory/$(basename $key)"
    if ! grep -q "^$key$" "$locks_directory"/* 2>/dev/null; then
        test_fail_messages+=("Klucz $key nie jest zablokowany.")
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;$(IFS='; '; echo "${test_fail_messages[*]}")"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
