#!/bin/bash

test_id="SEC-APPARMOR-PROFILES-ENFORCE-COMPLAIN-001"
test_name="Ensure all AppArmor Profiles are in enforce or complain mode"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Pobieranie statusu profili AppArmor za pomocą pełnej ścieżki
apparmor_status_output=$(/usr/sbin/apparmor_status)

# Sprawdzanie, czy wszystkie profile są w trybie egzekwowania lub narzekania
if ! echo "$apparmor_status_output" | grep -q "profiles are in enforce mode."; then
    test_fail_messages+=("Niektóre profile AppArmor nie są w trybie enforce.")
    exit_status=1
fi

if ! echo "$apparmor_status_output" | grep -q "profiles are in complain mode."; then
    test_fail_messages+=("Niektóre profile AppArmor nie są w trybie complain.")
    # Uwaga: brak profili w trybie narzekania nie jest koniecznie błędem
fi

# Sprawdzanie, czy istnieją nieograniczone procesy z zdefiniowanymi profilami
if echo "$apparmor_status_output" | grep -q "processes are unconfined but have a profile defined" && ! echo "$apparmor_status_output" | grep -q "0 processes are unconfined but have a profile defined"; then
    test_fail_messages+=("Istnieją procesy nieograniczone, ale z zdefiniowanymi profilami.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
