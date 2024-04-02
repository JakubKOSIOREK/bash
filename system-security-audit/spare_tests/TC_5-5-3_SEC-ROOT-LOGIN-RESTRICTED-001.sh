#!/usr/bin/env bash

test_id="SEC-ROOT-LOGIN-RESTRICTED-001"
test_name="Ensure root login is restricted to system console"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Plik zawierający listę bezpiecznych terminali
secure_tty_file="/etc/security/securetty"

# Lista zdefiniowanych konsol uznawanych za bezpieczne
# Dodaj lub usuń konsolę zgodnie z wymaganiami bezpieczeństwa
# Przykład: defined_consoles=("console" "ttyS0" "ttyS1" "ttyS2" "vc/63" "vc/62")
defined_consoles=()

# Sprawdzenie, czy plik securetty istnieje
if [[ ! -f "$secure_tty_file" ]]; then
    test_fail_message=("$secure_tty_file file not found.")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
    exit 1
fi

# Funkcja sprawdzająca, czy konsola jest na liście bezpiecznych
is_console_secure() {
    local console=$1
    for secure_console in "${defined_consoles[@]}"; do
        if [[ $console == $secure_console ]]; then
            return 0 # Konsola jest bezpieczna
        fi
    done
    return 1 # Konsola nie jest bezpieczna
}

# Tablica przechowująca niebezpieczne konsoli
insecure_consoles=()

# Odczyt i sprawdzenie każdej linii w securetty, ignorując linie zakomentowane
while IFS= read -r console; do
    # Pomijanie, jeśli linia jest zakomentowana
    if [[ $console == \#* || -z "$console" ]]; then
        continue
    fi

    if ! is_console_secure "$console"; then
        insecure_consoles+=("$console")
    fi
done < "$secure_tty_file"

# Sprawdzenie, czy znaleziono jakiekolwiek niebezpieczne konsole
if [[ ${#insecure_consoles[@]} -ne 0 ]]; then
    test_fail_messages+=("Insecure consoles found: '${insecure_consoles[*]}'.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
