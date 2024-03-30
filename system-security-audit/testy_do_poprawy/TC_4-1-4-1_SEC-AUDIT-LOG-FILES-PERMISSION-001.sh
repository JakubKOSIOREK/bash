#!/bin/bash

test_id="SEC-AUDIT-LOG-FILES-PERMISSION-001"
test_name="Ensure audit log files are mode 0640 or less permissive"
exit_status=0

# Sprawdzenie, czy plik konfiguracyjny audytu istnieje
if [ -f /etc/audit/auditd.conf ]; then
    # Znalezienie katalogu z plikami logów audytu
    log_dir="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Szukanie plików, które nie mają uprawnień 0640 lub mniej
    incorrect_perms_files=$(find "$log_dir" -type f \( ! -perm 600 -a ! -perm 0400 -a ! -perm 0200 -a ! -perm 0000 -a ! -perm 0640 -a ! -perm 0440 -a ! -perm 0040 \) -exec stat -Lc "%n %#a" {} +)
    
    if [ -n "$incorrect_perms_files" ]; then
        echo "FAIL;$test_id;$test_name; - Niektóre pliki dziennika audytu nie mają ustawionych uprawnień 0640 lub niższych. Zapoznaj się z poniższymi plikami i ich uprawnieniami:"
        echo "$incorrect_perms_files"
        exit_status=1
    else
        echo "PASS;$test_id;$test_name;"
    fi
else
    echo "FAIL;$test_id;$test_name; - Plik /etc/audit/auditd.conf nie istnieje."
    exit_status=1
fi

exit $exit_status
