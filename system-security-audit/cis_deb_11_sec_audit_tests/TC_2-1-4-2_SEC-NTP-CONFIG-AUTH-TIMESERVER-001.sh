#!/bin/bash

test_id="SEC-NTP-CONFIG-AUTH-TIMESERVER-001"
test_name="Ensure ntp is configured with authorized timeserver"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Lokalizacja pliku konfiguracyjnego ntp
ntp_conf="/etc/ntp.conf"

# Sprawdzenie, czy ntp jest używany na systemie
if [ ! -f "$ntp_conf" ]; then
    echo "N/A ;${test_id};${test_name};'ntp' nie jest zainstalowany."
    exit 0
fi

# Wyszukanie dyrektyw 'server' i 'pool' w pliku konfiguracyjnym
server_pool_lines=$(grep -P -- '^\s*(server|pool)\s+\S+' "$ntp_conf")

# Liczenie dyrektyw 'server'
server_lines=$(echo "$server_pool_lines" | grep -c '^server')

# Weryfikacja konfiguracji
if [[ -z "$server_pool_lines" ]]; then
    test_fail_messages+=("Nie znaleziono konfiguracji 'server' lub 'pool'.")
    exit_status=1
else
    if [[ $server_lines -lt 3 ]]; then
        test_fail_messages+=("Znaleziono mniej niż trzy dyrektywy 'server'.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
