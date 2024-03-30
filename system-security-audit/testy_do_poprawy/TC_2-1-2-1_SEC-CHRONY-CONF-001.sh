#!/bin/bash

test_id="SEC-CHRONY-CONF-001"
test_name="Ensure chrony is configured with authorized timeserver"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy 'chrony' jest zainstalowany
if ! command -v chronyc &> /dev/null; then
    echo "N/A;$test_id;$test_name; - 'chrony' nie jest zainstalowany."
    exit 0
fi

# Lokalizacja plików konfiguracyjnych chrony
chrony_conf_files="/etc/chrony/*.conf /etc/chrony/*.sources"

# Wyszukiwanie dyrektyw 'server' i 'pool' w plikach konfiguracyjnych chrony
server_lines=$(grep -Pr --include=*.{sources,conf} '^\s*(server|pool)\s+\S+' /etc/chrony/)

# Liczenie wystąpień dyrektyw
pool_count=$(echo "$server_lines" | grep -c '^pool')
server_count=$(echo "$server_lines" | grep -c '^server')

# Sprawdzenie, czy spełnione są wymagania
if [ "$pool_count" -lt 1 ] || [ "$server_count" -lt 3 ]; then
    test_fail_messages+=("Konfiguracja chrony nie zawiera co najmniej jednej dyrektywy 'pool' i/lub co najmniej trzech dyrektyw 'server'.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
