#!/bin/bash

# Ścieżka do pliku konfiguracyjnego
pwquality_conf_path="/etc/security/pwquality.conf"

# Funkcja aktualizująca ustawienie w pliku konfiguracyjnym
update_setting() {
    local setting_name=$1
    local expected_value=$2

    # Usunięcie istniejących ustawień (zakomentowanych i niezakomentowanych)
    sed -i "/^#\?\s*${setting_name}\s*=/d" "$pwquality_conf_path"

    # Dodanie nowego ustawienia na koniec pliku
    echo "${setting_name} = ${expected_value}" >> "$pwquality_conf_path"

    echo "Zaktualizowano ustawienie: ${setting_name} na ${expected_value}."
}

# Sprawdzenie, czy plik konfiguracyjny istnieje
if [ ! -f "$pwquality_conf_path" ]; then
    echo "Plik konfiguracyjny $pwquality_conf_path nie istnieje."
    exit 1
fi

# Ustawienia do zaktualizowania
echo "Aktualizowanie ustawień w $pwquality_conf_path..."
update_setting "minlen" "14"
update_setting "minclass" "4"
update_setting "dcredit" "-1"
update_setting "ucredit" "-1"
update_setting "ocredit" "-1"
update_setting "lcredit" "-1"

echo "Aktualizacja ustawień zakończona."
