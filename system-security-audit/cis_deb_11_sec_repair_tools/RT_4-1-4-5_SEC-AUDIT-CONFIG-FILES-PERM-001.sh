#!/bin/bash

# Ścieżka do katalogu z plikami konfiguracyjnymi audytu
audit_config_dir="/etc/audit/"

# Wyszukanie plików konfiguracyjnych audytu, także w podkatalogach
audit_config_files=$(find "$audit_config_dir" -type f \( -name '*.conf' -o -name '*.rules' \))

# Sprawdzenie, czy znaleziono jakiekolwiek pliki konfiguracyjne audytu
if [ -n "$audit_config_files" ]; then
    # Iteracja przez znalezione pliki
    while IFS= read -r config_file; do
        # Zmiana uprawnień na 640 i ustawienie właściciela oraz grupy na root
        chmod 640 "$config_file"
        chown root:root "$config_file"
        echo "Zmieniono uprawnienia i właściciela pliku: $config_file"
    done <<< "$audit_config_files"
else
    echo "Brak plików konfiguracyjnych audytu w katalogu $audit_config_dir."
fi
