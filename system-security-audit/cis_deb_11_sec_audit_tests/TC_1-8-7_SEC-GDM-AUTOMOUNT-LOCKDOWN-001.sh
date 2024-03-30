#!/bin/bash

test_id="SEC-GDM-AUTOMOUNT-LOCKDOWN-001"
file="/etc/dconf/db/local.d/locks"
test_name="Ensure GDM disabling automatic mounting of removable media is not overridden"
test_fail_messages=() # Tablica na komunikaty o błędach

# Pobranie ścieżki do skryptu i nazwy pliku
script_path="$0"
test_file=$(basename "$script_path")

exit_status=0

# Sprawdzenie, czy GDM jest zainstalowany
if ! dpkg-query -W -f='${Status}' gdm 2>/dev/null | grep -q "install ok installed" && ! dpkg-query -W -f='${Status}' gdm3 2>/dev/null | grep -q "install ok installed"; then
    echo "PASS;$test_id;$test_file;$test_name;"
    exit 0
fi

# Lista kluczy dconf, które powinny być zablokowane
keys_to_lock=(
    "/org/gnome/desktop/media-handling/automount"
    "/org/gnome/desktop/media-handling/automount-open"
)

# Sprawdzenie, czy katalog z blokadami istnieje
if [ ! -d "$file" ]; then
    echo "FAIL;$test_id;$test_file;$test_name;Katalog z blokadami dconf ($file) nie istnieje."
    exit 1
fi

# Sprawdzenie, czy wszystkie wymagane klucze są zablokowane
for key in "${keys_to_lock[@]}"; do
    lock_file_path="$file/$(basename $key)"
    if ! grep -q "^$key$" "$file"/* 2>/dev/null; then
        test_fail_messages+=("Klucz $key nie jest zablokowany.")
        exit_status=1
    fi
done

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=$'\n'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
