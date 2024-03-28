#!/bin/bash

test_id="SEC-GDM-BANNER-CONFIGURED-PROPERLY-001"
test_name="Ensure GDM login banner is configured properly"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Definiowanie ścieżki do pliku konfiguracyjnego GDM
gdm_conf="/etc/gdm3/greeter.dconf-defaults"

# Sprawdzenie, czy plik konfiguracyjny GDM istnieje
if [ ! -f "$gdm_conf" ]; then
    test_fail_messages+=(" - Plik konfiguracyjny GDM ($gdm_conf) nie istnieje.")
    exit_status=1
else
    # Sprawdzenie, czy /etc/issue.net zawiera niedozwolone informacje
    os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')

    if grep -E -i -q "(\\\v|\\\r|\\\m|\\\s|$os_id)" "$gdm_conf"; then
        test_fail_messages+=("Plik $gdm_conf zawiera niedozwolone informacje o systemie.")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;${test_fail_messages[*]}"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
