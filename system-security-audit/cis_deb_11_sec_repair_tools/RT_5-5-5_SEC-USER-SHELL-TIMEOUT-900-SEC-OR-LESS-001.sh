#!/bin/bash

# Funkcja do aktualizacji ustawienia TMOUT
update_tmout_setting() {
    local file=$1
    local has_tmout=$(grep -q "TMOUT=" "$file"; echo $?)

    if [ "$has_tmout" -eq 0 ]; then
        # Jeśli TMOUT istnieje, aktualizuj wpisy
        sed -i '/TMOUT=/c readonly TMOUT=900' "$file"
    else
        # Jeśli TMOUT nie istnieje, dodaj na końcu pliku
        echo 'readonly TMOUT=900' >> "$file"
    fi
}

# Ścieżki do plików, które należy sprawdzić
files_to_check=("/etc/bash.bashrc" "/etc/profile")

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "Aktualizacja ustawienia TMOUT w $file..."
        update_tmout_setting "$file"
    else
        echo "Plik $file nie istnieje."
    fi
done

echo "Aktualizacja zakończona."
