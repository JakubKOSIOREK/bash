#!/bin/bash

test_id="SEC-GDM-AUTOMOUNT-DISABLED-001"
test_name="Ensure GDM automatic mounting of removable media is disabled"
test_fail_messages=() # Tablica na komunikaty o błędach

# Pobranie ścieżki do skryptu i nazwy pliku
script_path="$0"
test_file=$(basename "$script_path")

# Sprawdzenie, czy GDM jest zainstalowany
if dpkg-query -W -f='${Status}' gdm3 2>/dev/null | grep -q "install ok installed"; then
    l_output=" - GNOME Desktop Manager (GDM) jest zainstalowany na systemie."
    
    # Sprawdzenie ustawień automatycznego montowania w dconf dla GDM
    auto_mount=$(gsettings get org.gnome.desktop.media-handling automount)
    auto_mount_open=$(gsettings get org.gnome.desktop.media-handling automount-open)

    if [ "$auto_mount" = true ]; then
        test_fail_messages+=("Automatyczne montowanie mediów jest włączone (automount).")
    fi

    if [ "$auto_mount_open" = true ]; then
        test_fail_messages+=("Automatyczne otwieranie nowo zamontowanych mediów jest włączone (automount-open).")
    fi

    # Raportowanie wyników
    if [ ${#test_fail_messages[@]} -eq 0 ]; then
        echo "PASS;${test_id};${test_file};${test_name};"
    else
        test_fail_message=$(IFS=$'\n'; echo "${test_fail_messages[*]}")
        echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
    fi
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
