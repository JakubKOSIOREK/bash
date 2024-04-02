#!/bin/bash

test_id="SEC-SUID-EXECUTABLES-001"
test_name="Audit SUID executables"
test_fail_messages=() # Tablica na komunikaty o błędach

script_path="$0"
test_file=$(basename "$script_path")

# Definicja listy plików do pominięcia jako tablica
skip_files=(
    "/bin/ping"
    "/usr/bin/passwd"
    
)

# Wykonanie polecenia w celu znalezienia plików z ustawionym bitem SUID
suid_files=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000)

exit_status=0

# Sprawdzenie, czy znaleziono jakiekolwiek pliki z ustawionym bitem SUID
if [ -n "$suid_files" ]; then
    # Przetwarzanie każdego znalezionego pliku
    while IFS= read -r file; do
        # Sprawdzenie, czy plik jest na liście pominiętych
        if [[ ! " ${skip_files[*]} " =~ " ${file} " ]]; then
            test_fail_messages+=("$file")
        fi
    done <<< "$suid_files"
    
    if [ ${#test_fail_messages[@]} -ne 0 ]; then
        exit_status=1
    fi
fi

# Kompilacja jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
fi

exit $exit_status
