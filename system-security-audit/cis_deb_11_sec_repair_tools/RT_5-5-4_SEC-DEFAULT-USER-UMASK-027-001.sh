#!/bin/bash

# Funkcja do aktualizacji ustawienia umask w pliku
update_umask_setting() {
    local file=$1
    # Sprawdzanie, czy w pliku jest już ustawienie umask
    local umask_exists=$(grep -E "^umask" "$file")

    if [[ -z "$umask_exists" ]]; then
        # Jeśli nie ma ustawienia umask, dodajemy je
        echo "Dodawanie 'umask 027' do $file."
        echo 'umask 027' >> "$file"
    else
        # Jeśli umask istnieje, ale jest nieodpowiednie, aktualizujemy je
        if [[ ! "$umask_exists" =~ umask\ 0(2[7-9]|3[0-7]) ]]; then
            echo "Aktualizacja ustawienia umask na 'umask 027' w $file."
            sed -i '/^umask/c\umask 027' "$file"
        else
            echo "Ustawienie umask w $file jest już odpowiednie."
        fi
    fi
}

# Ścieżki do plików, które mają zostać sprawdzone
files_to_check=("/etc/bash.bashrc" "/etc/profile")

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        update_umask_setting "$file"
    else
        echo "Plik $file nie istnieje."
    fi
done

echo "Aktualizacja ustawienia umask zakończona."
