#!/bin/bash

test_id="SEC-GROUP-BACKUP-PERM-001"
file="/etc/group-"
test_name="Ensure permissions on $file are configured"
test_fail_messages=() # Tablica na komunikaty o błędach

expected_permissions="600"
expected_owner="root"
expected_group="root"

script_path="$0"
test_file=$(basename "$script_path")

# Sprawdzenie, czy plik istnieje
if [ ! -f "$file" ]; then
    echo "FAIL;$test_id;;$test_name;Plik $file nie istnieje."
    exit 1
fi

actual_permissions=$(stat -c "%a" "$file")
actual_owner=$(stat -c "%U" "$file")
actual_group=$(stat -c "%G" "$file")

exit_status=0

# Funkcja sprawdzająca zgodność uprawnień
check_permission() {
    local expected=$1
    local actual=$2
    local type=$3
    if [ "$actual" != "$expected" ]; then
        test_fail_messages+=(" - $type: $actual (expected: $expected)")
        exit_status=1
    fi
}

check_permission "$expected_permissions" "$actual_permissions" "uprawnienia"
check_permission "$expected_owner" "$actual_owner" "właściciel"
check_permission "$expected_group" "$actual_group" "grupa"

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
fi

exit $exit_status
