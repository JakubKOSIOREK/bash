#!/bin/bash

test_id="SEC-AUDIT-LOG-FILES-GROUP-OWNERSHIP-001"
test_name="Ensure only authorized groups are assigned ownership of audit log files"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy plik konfiguracyjny audytu istnieje
if [ -f /etc/audit/auditd.conf ]; then
    # Pobranie nazwy grupy z pliku konfiguracyjnego
    log_group=$(grep -Piw -- '^\h*log_group\h*=\h*(adm|root)\b' /etc/audit/auditd.conf | cut -d '=' -f 2 | xargs)
    
    # Sprawdzenie, czy grupa jest prawidłowa
    if [ "$log_group" != "adm" ] && [ "$log_group" != "root" ]; then
        test_fail_messages+=("Niewłasciwe ustawienie w /etc/audit/auditd.conf. Oczekiwana wartość 'log_group' to be 'adm' or 'root'.")
        exit_status=1
    fi
    
    # Pobranie ścieżki katalogu z plikami logów audytu
    log_dir=$(dirname "$(grep -Po '^\s*log_file\s*=\s*\K\S+' /etc/audit/auditd.conf)")

    # Sprawdzenie, czy pliki są własnością odpowiedniej grupy
    files_not_owned_by_authorized_group=$(stat -c "%n %G" "$log_dir"/* | grep -Pv '^\h*\H+\h+(adm|root)\b')
    
    if [ -n "$files_not_owned_by_authorized_group" ]; then
        test_fail_messages+=("Niektóre pliki dziennika kontroli nie są własnością autoryzowanej grupy.")
        exit_status=1
    fi
else
    test_fail_messages+=("Plik /etc/audit/auditd.conf nie istnieje.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=""
for message in "${test_fail_messages[@]}"; do
    test_fail_message+=" $message"
done

test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
