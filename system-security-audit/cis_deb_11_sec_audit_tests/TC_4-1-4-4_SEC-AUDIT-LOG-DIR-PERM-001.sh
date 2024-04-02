#!/bin/bash

test_id="SEC-AUDIT-LOG-DIR-PERM-001"
test_name="Ensure the audit log directory is 0750 or more restrictive"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy plik konfiguracyjny audytu istnieje
if [ -f /etc/audit/auditd.conf ]; then
    # Pobranie ścieżki katalogu z plikami logów audytu z pliku konfiguracyjnego
    log_dir=$(dirname "$(awk -F "=" '/^\s*log_file\s*=\s*/ {print $2}' /etc/audit/auditd.conf | xargs)")
    
    # Sprawdzenie, czy katalog ma prawidłowe uprawnienia
    if ! stat -Lc "%n %a" "$log_dir" | grep -Pq -- '^\h*\H+\h+([0,5,7][0,5]0)'; then
        test_fail_messages+=("Katalog dziennika kontroli nie ma uprawnień 0750 lub bardziej restrykcyjnych.")
        exit_status=1
    fi
else
    test_fail_messages+=("Plik /etc/audit/auditd.conf nie istnieje.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
