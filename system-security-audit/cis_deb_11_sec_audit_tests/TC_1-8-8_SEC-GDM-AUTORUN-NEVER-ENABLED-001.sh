#!/bin/bash

test_id="SEC-GDM-AUTORUN-NEVER-ENABLED-001"
file="/etc/dconf/db/local.d/locks"
test_name="Ensure GDM autorun-never is enabled"
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

# Definiowanie ścieżki i nazwy klucza dconf do sprawdzenia
key_name="/org/gnome/desktop/lockdown/disable-user-switching"

# Sprawdzenie, czy katalog z blokadami istnieje
if [ ! -d "$file" ]; then
    echo "FAIL;$test_id;$test_file;$test_name;Katalog z blokadami dconf ($file) nie istnieje."
    exit 1
fi

# Sprawdzenie, czy klucz autorun-never jest zablokowany
lock_file_path="$file/$(basename "$key_name")"
if ! grep -q "^$key_name$" "$file"/* 2>/dev/null; then
    test_fail_messages+=("Klucz $key_name nie jest zablokowany.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_file;$test_name;"
fi

exit $exit_status
