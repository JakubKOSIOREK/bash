#!/bin/bash

user="root"
group="root"
perm=700

# Ścieżka do pliku
file_path="/etc/cron.weekly/"

# Sprawdzenie, czy skrypt jest uruchomiony z uprawnieniami superużytkownika
if [ "$(id -u)" -ne 0 ]; then
    echo "Ten skrypt wymaga uprawnień superużytkownika. Uruchom go ponownie za pomocą 'sudo'."
    exit 1
fi

# Sprawdzenie, czy katalog istnieje
if [ ! -d "$file_path" ]; then
    echo "Plik '$file_path' nie istnieje."
    exit 2
fi

# Zmiana właściciela katalogu na root:root
chown $user:$group "$file_path"

# Zmiana uprawnień pliku na 600
chmod $perm "$file_path"

echo "Uprawnienia i właściciel '$file_path' zostały zmienione."
