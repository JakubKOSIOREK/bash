#!/bin/bash

user="root"
group="root"
perm=600

# Ścieżka do pliku
file_path="/etc/crontab"

# Sprawdzenie, czy skrypt jest uruchomiony z uprawnieniami superużytkownika
if [ "$(id -u)" -ne 0 ]; then
    echo "Ten skrypt wymaga uprawnień superużytkownika. Uruchom go ponownie za pomocą 'sudo'."
    exit 1
fi

# Sprawdzenie, czy plik istnieje
if [ ! -f "$file_path" ]; then
    echo "Plik '$file_path' nie istnieje."
    exit 2
fi

# Zmiana właściciela pliku na root:root
chown $user:$group "$file_path"

# Zmiana uprawnień pliku na 600
chmod $perm "$file_path"

echo "Uprawnienia i właściciel pliku '$file_path' zostały zmienione."