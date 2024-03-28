#!/bin/bash

test_id="SEC-AUDIT-LOG-FILES-OWNERSHIP-001"
test_name="Ensure only authorized users own audit log files"
exit_status=0

# Sprawdzenie, czy plik konfiguracyjny audytu istnieje
if [ -f /etc/audit/auditd.conf ]; then
    # Znalezienie katalogu z plikami logów audytu
    log_dir="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Szukanie plików, które nie są własnością użytkownika root
    files_not_owned_by_root=$(find "$log_dir" -type f ! -user root -exec stat -Lc "%n %U" {} +)
    
    if [ -n "$files_not_owned_by_root" ]; then
        echo "FAIL;$test_id;$test_name; - Niektóre pliki dziennika audytu nie są własnością użytkownika root. Zapoznaj się z poniższymi plikami i ich właścicielami:"
        echo "$files_not_owned_by_root"
        exit_status=1
    else
        echo "PASS;$test_id;$test_name;"
    fi
else
    echo "FAIL;$test_id;$test_name; - Plik /etc/audit/auditd.conf nie istnieje."
    exit_status=1
fi

exit $exit_status
