#!/bin/bash

test_id="SEC-ETCISSUENET-PERM-001"
file="/etc/issue.net"
test_name="Ensure permissions on $file are configured"
test_fail_messages=() # Tablica na komunikaty o błędach

expected_permissions="644"
expected_owner="root"
expected_group="root"

# Pobranie ścieżki do skryptu i nazwy pliku
script_path="$0"
test_file=$(basename "$script_path")

# Sprawdzenie, czy plik $file istnieje
if [ ! -f "$file" ]; then
    echo "N/A;$test_id;$test_file;$test_name; - Plik $file nie istnieje."
    exit 0
fi

actual_permissions=$(stat -c "%a" "$file")
actual_owner=$(stat -c "%U" "$file")
actual_group=$(stat -c "%G" "$file")

exit_status=0

if [ "$actual_permissions" != "$expected_permissions" ]; then
    test_fail_messages+=(" - Nieprawidłowe uprawnienia: $actual_permissions (oczekiwane: $expected_permissions)")
    exit_status=1
fi

if [ "$actual_owner" != "$expected_owner" ]; then
    test_fail_messages+=(" - Nieprawidłowy właściciel: $actual_owner (oczekiwany: $expected_owner)")
    exit_status=1
fi

if [ "$actual_group" != "$expected_group" ]; then
    test_fail_messages+=(" - Nieprawidłowa grupa: $actual_group (oczekiwana: $expected_group)")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

if [ "$exit_status" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
