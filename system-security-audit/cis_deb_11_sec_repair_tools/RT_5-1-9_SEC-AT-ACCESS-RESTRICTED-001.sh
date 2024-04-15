#!/bin/bash

# Usunięcie pliku /etc/at.deny, jeśli istnieje
if [ -f "/etc/at.deny" ]; then
    rm /etc/at.deny
    echo "Usunięto plik /etc/at.deny."
else
    echo "Plik /etc/at.deny nie istnieje, pomijanie."
fi

# Tworzenie pliku /etc/at.allow, jeśli nie istnieje
if [ ! -f "/etc/at.allow" ]; then
    touch /etc/at.allow
    echo "Utworzono plik /etc/at.allow."
else
    echo "Plik /etc/at.allow już istnieje."
fi

# Ustawienie odpowiednich uprawnień dla /etc/at.allow
chmod g-wx,o-rwx /etc/at.allow
echo "Ustawiono uprawnienia dla /etc/at.allow na g-wx,o-rwx."

# Ustawienie właściciela pliku /etc/at.allow na root:root
chown root:root /etc/at.allow
echo "Ustawiono właściciela pliku /etc/at.allow na root:root."

echo "Skrypt naprawczy zakończył działanie."
