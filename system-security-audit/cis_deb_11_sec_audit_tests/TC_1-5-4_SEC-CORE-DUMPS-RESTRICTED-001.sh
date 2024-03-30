#!/bin/bash

test_id="SEC-CORE-DUMPS-RESTRICTED-001"
test_name="Ensure core dumps are restricted"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy istnieją jakiekolwiek ustawienia dotyczące zrzutów rdzenia
core_dump_settings=$(grep -rE '^(\*|\s).*hard.*core.*(\s+#.*)?$' /etc/security/limits.conf /etc/security/limits.d/* 2>/dev/null)

if [ -n "$core_dump_settings" ]; then
    # Przechodzimy przez wszystkie pliki konfiguracyjne, aby znaleźć, które z nich zawierają ustawienia dotyczące zrzutów rdzenia
    while IFS= read -r file_with_setting; do
        file=$(echo "$file_with_setting" | cut -d ':' -f 1)
        setting=$(echo "$file_with_setting" | cut -d ':' -f 2-)
        if grep -qE '^(\*|\s).*hard.*core.*(\s+#.*)?$' "$file" && echo "$setting" | grep -q '0'; then
            #echo "Znaleziono ustawienie ograniczenia zrzutów rdzenia w pliku: $file"
            exit_status=0
            # Sprawdzenie, czy wartość ustawienia jest równa oczekiwanej wartości (0)
            if [ "$(echo "$setting" | awk '{print $NF}')" != "0" ]; then
                test_fail_messages+=("Oczekiwana wartość ustawienia: 0, odczytana wartość: $(echo "$setting" | awk '{print $NF}') w pliku: $file")
                exit_status=1
            fi
            break
        fi
    done <<< "$core_dump_settings"
else
    #echo "Brak ustawień ograniczeń zrzutów rdzenia w systemie."
    test_fail_messages+=("Brak ustawień ograniczeń zrzutów rdzenia w systemie.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
fi

exit $exit_status
