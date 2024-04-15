#!/bin/bash

test_id="SEC-AUDIT-LOG-FILES-OWNERSHIP-001"
test_name="Ensure only authorized users own audit log files"
exit_status=0

# Pobranie nazwy i ścieżki bieżącego skryptu
script_path="$0"
test_file=$(basename "$script_path")

# Sprawdzenie, czy plik konfiguracyjny audytu istnieje
if [ -f /etc/audit/auditd.conf ]; then
    # Znalezienie katalogu z plikami logów audytu
    log_dir="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Szukanie plików, które nie są własnością użytkownika root
    files_not_owned_by_root=$(find "$log_dir" -type f ! -user root -exec stat -Lc "%n %U" {} +)
    
    if [ -n "$files_not_owned_by_root" ]; then
        test_fail_message=$(echo "$files_not_owned_by_root" | tr '\n' ';')
        echo "FAIL;$test_id;$test_file;$script_path;$test_name;Niektóre pliki dziennika audytu nie są własnością użytkownika root.;$test_fail_message"
        exit_status=1
    else
        echo "PASS;$test_id;$test_file;$test_name;"
    fi
else
    echo "FAIL;$test_id;$test_file;$test_name; - Plik /etc/audit/auditd.conf nie istnieje."
    exit_status=1
fi

exit $exit_status
