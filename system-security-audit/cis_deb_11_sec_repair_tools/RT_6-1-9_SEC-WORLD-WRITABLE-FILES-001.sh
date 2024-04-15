#!/bin/bash

# Zmienna z nazwą pliku
file_name="/boot/hd-background-tzk.png"

# Sprawdzenie, czy plik istnieje
if [ -f "$file_name" ]; then
    # Zmiana uprawnień pliku na tylko do odczytu dla wszystkich
    sudo chmod 444 "$file_name"
    echo "Uprawnienia pliku '$file_name' zostały zmienione na tylko do odczytu dla wszystkich."
else
    echo "Plik '$file_name' nie istnieje."
fi
