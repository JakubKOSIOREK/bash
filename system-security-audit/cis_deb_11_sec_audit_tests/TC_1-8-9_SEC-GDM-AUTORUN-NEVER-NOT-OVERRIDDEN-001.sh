#!/bin/bash

test_id="SEC-GDM-AUTORUN-NEVER-NOT-OVERRIDDEN-001"
test_name="Ensure GDM autorun-never is not overridden"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Pobranie ścieżki do skryptu i nazwy pliku
script_path="$0"
test_file=$(basename "$script_path")

# Definiowanie ścieżki do katalogu z blokadami dconf
locks_directory="/etc/dconf/db/local.d/locks"

# Sprawdzenie, czy GDM jest zainstalowany
if ! dpkg-query -W -f='${Status}' gdm 2>/dev/null | grep -q "install ok installed" && ! dpkg-query -W -f='${Status}' gdm3 2>/dev/null | grep -q "install ok installed"; then
    echo "PASS;$test_id;$test_file;$test_name;"
    exit 0
fi

# Klucz dconf, który powinien być zablokowany
key_to_lock="/org/gnome/desktop/media-handling/autorun-never"

# Sprawdzenie, czy katalog z blokadami istnieje
if [ ! -d "$locks_directory" ]; then
    test_fail_messages+=("Katalog z blokadami dconf ($locks_directory) nie istnieje.")
    exit_status=1
else
    # Sprawdzenie, czy klucz autorun-never jest zablokowany
    if ! grep -q "^$key_to_lock$" "$locks_directory"/* 2>/dev/null; then
        test_fail_messages+=("Klucz $key_to_lock nie jest zablokowany.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_message=$(IFS=$'\n'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
