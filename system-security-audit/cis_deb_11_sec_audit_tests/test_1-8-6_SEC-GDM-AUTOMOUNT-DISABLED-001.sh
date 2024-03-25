#!/usr/bin/env bash

test_id="SEC-GDM-AUTOMOUNT-DISABLED-001"
test_name="Ensure GDM automatic mounting of removable media is disabled"
l_output=""
l_output2=""

# Sprawdzenie, czy GDM jest zainstalowany
if dpkg-query -W -f='${Status}' gdm3 2>/dev/null | grep -q "install ok installed"; then
    l_output="\n - GNOME Desktop Manager (GDM) jest zainstalowany na systemie."
    
    # Sprawdzenie ustawień automatycznego montowania w dconf dla GDM
    auto_mount=$(gsettings get org.gnome.desktop.media-handling automount)
    auto_mount_open=$(gsettings get org.gnome.desktop.media-handling automount-open)

    if [ "$auto_mount" != "false" ]; then
        l_output2="$l_output2\n - Automatyczne montowanie mediów jest włączone (automount)."
    fi

    if [ "$auto_mount_open" != "false" ]; then
        l_output2="$l_output2\n - Automatyczne otwieranie nowo zamontowanych mediów jest włączone (automount-open)."
    fi

    # Raportowanie wyników
    if [ -z "$l_output2" ]; then
        echo "PASS;$test_id;$test_name;"
    else
        echo "FAIL;$test_id;$test_name; - Wymagane wyłączenie automatycznego montowania mediów.$l_output2"
    fi
else
    echo "PASS;$test_id;$test_name;"
fi
