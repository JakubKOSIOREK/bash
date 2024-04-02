#!/bin/bash

test_id="SEC-UNOWNED-FILES-DIRS-001"
test_name="Ensure no unowned files or directories exist"
test_fail_messages=() # Tablica na komunikaty o błędach

script_path="$0"
test_file=$(basename "$script_path")

# Wykonanie polecenia w celu znalezienia plików i katalogów bez właściciela
unowned_items=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nouser)

exit_status=0

# Sprawdzenie, czy znaleziono jakiekolwiek pliki lub katalogi bez właściciela
if [ -n "$unowned_items" ]; then
    # Przetwarzanie każdego znalezionego elementu
    while IFS= read -r item; do
        test_fail_messages+=("$item")
    done <<< "$unowned_items"
    exit_status=1
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
