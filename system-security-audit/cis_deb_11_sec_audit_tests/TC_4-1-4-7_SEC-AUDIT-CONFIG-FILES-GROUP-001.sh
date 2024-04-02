#!/bin/bash

test_id="SEC-AUDIT-CONFIG-FILES-GROUP-001"
test_name="Ensure audit configuration files belong to group root"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy istnieją pliki konfiguracyjne audytu w katalogu /etc/audit/
audit_config_files=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \))

# Sprawdzenie, czy znaleziono jakiekolwiek pliki konfiguracyjne audytu
if [ -n "$audit_config_files" ]; then
    # Iteracja przez znalezione pliki
    while IFS= read -r config_file; do
        # Sprawdzenie grupy dla każdego pliku konfiguracyjnego
        file_group=$(stat -c "%G" "$config_file")
        # Sprawdzenie, czy grupa jest równa root
        if [ "$file_group" != "root" ]; then
            test_fail_messages+=("Plik konfiguracyjny audytu $config_file nie należy do grupy root.")
            exit_status=1
        fi
    done <<< "$audit_config_files"
else
    test_fail_messages+=("Brak plików konfiguracyjnych audytu w katalogu /etc/audit/.")
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
