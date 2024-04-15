#!/bin/bash

# Definiowanie ścieżek
source_file="./tzk_szgdk_config_files/aide.conf.d/audit_tools.conf"
destination_dir="/etc/aide/aide.conf.d/"
destination_file="${destination_dir}audit_tools.conf"

# Kopiowanie pliku konfiguracyjnego do katalogu systemowego
cp "$source_file" "$destination_dir"

# Sprawdzenie, czy plik został skopiowany
if [ -f "$destination_file" ]; then
    echo "Plik konfiguracyjny został skopiowany do $destination_dir."
else
    echo "Wystąpił problem z kopiowaniem pliku konfiguracyjnego. Sprawdź ścieżki i uprawnienia."
    exit 1
fi

# Dodanie nowych ustawień do skopiowanego pliku, jeśli jeszcze ich nie ma
if ! grep -q "p+i+n+u+g+s+b+acl+xattrs+sha512" "$destination_file"; then
    cat << EOF >> "$destination_file"
# Dodatkowe konfiguracje zabezpieczeń
/sbin/auditctl p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/auditd p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/ausearch p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/aureport p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/autrace p+i+n+u+g+s+b+acl+xattrs+sha512
/sbin/augenrules p+i+n+u+g+s+b+acl+xattrs+sha512
EOF
    echo "Zaktualizowano plik konfiguracyjny w $destination_file."
fi

# Informacja o potrzebie zainicjowania nowej bazy danych AIDE
echo "Aby zastosować zmiany, zainicjuj nową bazę danych AIDE za pomocą 'aide --init' i sprawdź za pomocą 'aide --check'."
