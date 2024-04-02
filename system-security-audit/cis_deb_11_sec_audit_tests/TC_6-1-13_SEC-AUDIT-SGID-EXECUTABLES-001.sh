#!/usr/bin/env bash

test_id="SEC-AUDIT-SGID-EXECUTABLES-001"
test_name="Audit SGID executables"

script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Oczekiwana lista plików SGID
skip_files=(
    "/usr/bin/at"
    "/usr/bin/crontab"
)

# Pozyskiwanie aktualnej listy plików SGID
actual_list=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000)

# Sprawdzanie nieoczekiwanych plików SGID
extra_files=()
while IFS= read -r file; do
    if [[ ! " ${skip_files[*]} " =~ " ${file} " ]]; then
        extra_files+=("$file")
    fi
done <<< "$actual_list"

# Sprawdzenie, czy istnieją dodatkowe pliki SGID, których nie oczekiwano
if [ ${#extra_files[@]} -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    # Dodawanie nieoczekiwanych plików SGID do komunikatów o błędach
    test_fail_message=$(IFS='; '; echo "${extra_files[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
    exit_status=1
fi

exit $exit_status
