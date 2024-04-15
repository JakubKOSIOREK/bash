#!/bin/bash

# Ścieżka do pliku konfiguracyjnego
pam_su_file="/etc/pam.d/su"

# Dyrektywa do dodania
directive="auth required pam_wheel.so use_uid group=sudo"

# Sprawdzenie, czy grupa sudo istnieje
if getent group sudo > /dev/null; then
    # Sprawdzenie, czy dyrektywa już istnieje
    if ! grep -Fxq "$directive" "$pam_su_file"; then
        # Tworzenie kopii zapasowej pliku
        cp "$pam_su_file" "${pam_su_file}.bak"
        
        # Dodanie dyrektywy
        echo "$directive" >> "$pam_su_file"
        echo "Dyrektywa dodana do $pam_su_file."
    else
        echo "Dyrektywa już istnieje w $pam_su_file."
    fi
else
    echo "Grupa 'sudo' nie istnieje."
    exit 1
fi
