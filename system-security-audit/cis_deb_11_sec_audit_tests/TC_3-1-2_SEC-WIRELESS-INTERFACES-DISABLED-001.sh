#!/bin/bash

test_id="SEC-WIRELESS-INTERFACES-DISABLED-001"
test_name="Ensure wireless interfaces are disabled"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy narzędzie nmcli jest dostępne
if command -v nmcli >/dev/null 2>&1; then
    # Użycie nmcli do sprawdzenia statusu radiowych interfejsów bezprzewodowych
    if ! nmcli radio all | grep -Eq '\s*\S+\s+disabled\s+\S+\s+disabled\b'; then
        test_fail_messages+=("Niektóre interfejsy bezprzewodowe mogą być włączone (nmcli).")
        exit_status=1
    fi
else
    # Wyszukiwanie interfejsów bezprzewodowych w systemie plików
    if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
        t=0
        # Wyszukiwanie unikalnych nazw modułów sterowników
        mname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driverdir"/device/driver/module)"; done | sort -u)
        # Sprawdzenie, czy moduły są wyłączone
        for dm in $mname; do
            if ! grep -Eq "^\s*install\s+$dm\s+/bin/(true|false)" /etc/modprobe.d/*.conf; then
                test_fail_messages+=("Sterownik bezprzewodowy $dm nie jest wyłączony.")
                t=1
            fi
        done
        if [ "$t" -eq 1 ]; then
            exit_status=1
        fi
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo -e "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
