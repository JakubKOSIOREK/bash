#!/bin/bash

test_id="SEC-APPARMOR-ALL-ENFORCING-001"
test_name="Ensure all AppArmor Profiles are enforcing"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Pobranie statusu AppArmor
apparmor_status_output=$(/usr/sbin/apparmor_status)

# Sprawdzenie, czy istnieją profile nie będące w trybie egzekwowania (complain mode)
if echo "$apparmor_status_output" | grep -qE "^[[:digit:]]+ profiles are in complain mode." && ! echo "$apparmor_status_output" | grep -qE "0 profiles are in complain mode."; then
    test_fail_messages+=("Istnieją profile AppArmor w trybie narzekania.")
    exit_status=1
fi

# Sprawdzenie, czy liczba profili w trybie egzekwowania odpowiada całkowitej liczbie załadowanych profili
total_profiles=$(echo "$apparmor_status_output" | grep -oP "(?<=^)[[:digit:]]+(?= profiles are loaded.)")
enforce_profiles=$(echo "$apparmor_status_output" | grep -oP "(?<=^)[[:digit:]]+(?= profiles are in enforce mode.)")

if [[ "$total_profiles" != "$enforce_profiles" ]]; then
    test_fail_messages+=("Nie wszystkie profile AppArmor są w trybie egzekwowania.")
    exit_status=1
fi

# Sprawdzenie, czy żaden z procesów nie jest nieograniczony
if echo "$apparmor_status_output" | grep -qE "^[[:digit:]]+ processes are unconfined" && ! echo "$apparmor_status_output" | grep -qE "0 processes are unconfined"; then
    test_fail_messages+=("Istnieją procesy nieograniczone.")
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
