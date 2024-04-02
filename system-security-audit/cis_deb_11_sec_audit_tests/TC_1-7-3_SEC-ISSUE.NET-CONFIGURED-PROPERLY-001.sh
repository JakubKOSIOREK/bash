#!/bin/bash

test_id="SEC-ISSUE.NET-CONFIGURED-PROPERLY-001"
test_name="Ensure remote login warning banner is configured properly"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Definiowanie ścieżki do pliku
file="/etc/issue.net"

# Pobranie identyfikatora dystrybucji z /etc/os-release
os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')

# Sprawdzenie, czy plik $file istnieje
if [ ! -f "$file" ]; then
    echo "N/A ;${test_id};${test_file};${test_name}; - Plik $file nie istnieje."
    exit 0
fi

# Sprawdzenie, czy $file nie zawiera potencjalnie wrażliwych informacji
if grep -Eis "(\\\v|\\\r|\\\m|\\\s|$os_id)" "$file" &> /dev/null; then
    test_fail_messages+=("Plik $file może zawierać informacje o systemie.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_messages[*]}"
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
