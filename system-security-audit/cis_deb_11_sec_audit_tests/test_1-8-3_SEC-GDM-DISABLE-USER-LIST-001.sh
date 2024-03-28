#!/bin/bash

test_id="SEC-GDM-DISABLE-USER-LIST-001"
test_name="Ensure GDM disable-user-list option is enabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy GDM jest zainstalowany
if ! command -v gdm &> /dev/null; then
    echo "N/A;$test_id;$test_name;GDM nie jest zainstalowany."
    exit 0
fi

# Sprawdzenie, czy GNOME jest używane
if ! pgrep -x gnome-session &> /dev/null; then
    echo "N/A;$test_id;$test_name;GNOME nie jest używane."
    exit 0
fi

# Sprawdzenie ustawienia disable-user-list za pomocą gsettings lub dconf
user_list_disabled=$(gsettings get org.gnome.login-screen disable-user-list 2>/dev/null)

if [ "$user_list_disabled" != "true" ]; then
    # Spróbuj sprawdzić ustawienie za pomocą dconf, jeśli gsettings nie zwróciło oczekiwanej odpowiedzi
    user_list_disabled=$(sudo -u gdm dbus-launch gsettings get org.gnome.login-screen disable-user-list 2>/dev/null)
    
    if [ "$user_list_disabled" != "true" ]; then
        test_fail_messages+=(" - Opcja disable-user-list GDM nie jest włączona.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;${test_fail_messages[*]}"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
