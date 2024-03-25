#!/bin/bash

test_id="SEC-TIME-SYNCH-001"
test_name="Ensure a single time synchronization daemon is in use"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lista demonów synchronizacji czasu do sprawdzenia
time_daemons=("chrony" "systemd-timesyncd" "ntp")

active_daemons=0 # Licznik aktywnych demonów

for daemon in "${time_daemons[@]}"; do
    # Sprawdzenie, czy demon jest aktywny
    if systemctl is-active --quiet $daemon 2>/dev/null; then
        active_daemons=$((active_daemons+1))
        # Dodanie komunikatu o aktywnym demonie
        test_fail_messages+=("$daemon jest aktywny.")
    fi
done

# Sprawdzenie, czy liczba aktywnych demonów jest równa 1
if [ "$active_daemons" -ne 1 ]; then
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=', '; echo "Błąd: ${test_fail_messages[*]} - Aktywnych jest $active_daemons demonów synchronizacji czasu, zalecany jest tylko jeden.")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
