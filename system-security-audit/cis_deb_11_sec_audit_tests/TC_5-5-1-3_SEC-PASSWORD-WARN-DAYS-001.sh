#!/usr/bin/env bash

test_id="SEC-PASSWORD-WARN-DAYS-001"
test_name="Ensure password expiration warning days is 7 or more"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0
expected_warn_days=7

# Sprawdzenie PASS_WARN_AGE w /etc/login.defs
warn_age=$(grep "^PASS_WARN_AGE" /etc/login.defs | awk '{ print $2 }')
warn_age=${warn_age:-0}  # Zapewnia wartość domyślną 0, jeśli warn_age jest puste

# Sprawdzenie, czy PASS_WARN_AGE jest poprawnie ustawiony
if [ -z "$warn_age" ] || [ "$warn_age" -lt $expected_warn_days ]; then
    test_fail_messages+=("PASS_WARN_AGE is less than $expected_warn_days or not set. Current value: $warn_age.")
    exit_status=1
fi

# Sprawdzenie wieku ostrzeżenia o hasle dla każdego użytkownika
while IFS=':' read -r user pass warn_age_rest; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ "${warn_age_rest:-0}" -lt $expected_warn_days ]; then
            test_fail_messages+=("User $user has PASS_WARN_AGE less than $expected_warn_days. Current value: $warn_age_rest.")
            exit_status=1
        fi
    fi
done < <(cut -d: -f1,2,6 /etc/shadow)

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
