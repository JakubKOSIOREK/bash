#!/bin/bash

# Lokalizacja i nazwa nowego pliku konfiguracyjnego
new_sudoers_file="/etc/sudoers.d/sudo_log"

# Dyrektywa do dodania
directive="Defaults logfile=\"/var/log/sudo.log\""

# Sprawdzenie, czy dyrektywa jest już obecna
if grep -qP -- "$directive" /etc/sudoers /etc/sudoers.d/*; then
    echo "Dyrektywa jest już obecna w konfiguracji sudo."
else
    echo "Dodawanie dyrektywy do $new_sudoers_file."
    # Tworzenie nowego pliku i dodawanie dyrektywy
    echo "$directive" | sudo EDITOR="tee" visudo -f $new_sudoers_file > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "Dyrektywa została pomyślnie dodana."
    else
        echo "Wystąpił błąd podczas dodawania dyrektywy."
        exit 1
    fi
fi
