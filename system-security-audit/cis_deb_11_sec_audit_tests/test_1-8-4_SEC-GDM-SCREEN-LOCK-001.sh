#!/bin/bash

test_id="SEC-GDM-SCREEN-LOCK-001"
test_name="Ensure GDM screen locks when the user is idle"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy gsettings jest dostępne
if ! command -v gsettings &> /dev/null; then
    echo "PASS;$test_id;$test_name; - gsettings nie znaleziono, pomijanie testu w środowisku bez GUI."
    exit 0
fi

# Sprawdzenie konfiguracji opóźnienia blokady ekranu
idle_delay=$(gsettings get org.gnome.desktop.session idle-delay)
lock_delay=$(gsettings get org.gnome.desktop.screensaver lock-delay)

# Zalecane ustawienia
recommended_idle_delay="uint32 900"  # 15 minut
recommended_lock_delay="uint32 5"    # 5 sekund

if [ "$idle_delay" != "$recommended_idle_delay" ]; then
    test_fail_messages+=("Nieprawidłowa konfiguracja idle-delay: $idle_delay, oczekiwano: $recommended_idle_delay.")
    exit_status=1
fi

if [ "$lock_delay" != "$recommended_lock_delay" ]; then
    test_fail_messages+=("Nieprawidłowa konfiguracja lock-delay: $lock_delay, oczekiwano: $recommended_lock_delay.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;${test_fail_messages[*]}"
else
    echo "PASS;$test_id;$test_name; - Konfiguracja blokady ekranu GDM jest prawidłowa."
fi

exit $exit_status
