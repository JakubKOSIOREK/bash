#!/bin/bash

test_id="SEC-LOG-FILE-PERMISSIONS-001"
test_name="Ensure all logfiles have appropriate permissions and ownership"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Zdefiniowanie docelowych uprawnień i właściciela
desired_permissions="640"
desired_owner="root"
desired_group="adm"

# Sprawdzenie plików dziennika w katalogu /var/log/ i opcjonalnie innych lokalizacjach
log_directories=("/var/log/") # Dodaj inne lokalizacje, jeśli to konieczne "/custom/log/location/"
for dir in "${log_directories[@]}"; do
    if [ -d "$dir" ]; then
        find "$dir" -type f ! -perm $desired_permissions ! -user $desired_owner ! -group $desired_group -exec ls -l {} + > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            test_fail_messages+=("Niektóre pliki w katalogu $dir nie mają oczekiwanych uprawnień, właściciela lub grupy.")
            exit_status=1
        fi
    else
        test_fail_messages+=("Katalog $dir nie istnieje.")
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
