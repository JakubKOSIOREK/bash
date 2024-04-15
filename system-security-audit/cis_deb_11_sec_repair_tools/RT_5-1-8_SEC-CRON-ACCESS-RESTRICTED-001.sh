#!/bin/bash

# Usunięcie pliku /etc/cron.deny, jeśli istnieje
if [ -f "/etc/cron.deny" ]; then
    rm /etc/cron.deny
    echo "Usunięto plik /etc/cron.deny."
else
    echo "Plik /etc/cron.deny nie istnieje, pomijanie."
fi

# Tworzenie pliku /etc/cron.allow, jeśli nie istnieje
if [ ! -f "/etc/cron.allow" ]; then
    touch /etc/cron.allow
    echo "Utworzono plik /etc/cron.allow."
else
    echo "Plik /etc/cron.allow już istnieje."
fi

# Ustawienie odpowiednich uprawnień dla /etc/cron.allow
chmod g-wx,o-rwx /etc/cron.allow
echo "Ustawiono uprawnienia dla /etc/cron.allow na g-wx,o-rwx."

# Ustawienie właściciela pliku /etc/cron.allow na root:root
chown root:root /etc/cron.allow
echo "Ustawiono właściciela pliku /etc/cron.allow na root:root."

echo "Skrypt naprawczy zakończył działanie."
