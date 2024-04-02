#!/usr/bin/env bash

test_id="SEC-PASSWORD-MAX-DAYS-001"
test_name="Ensure password expiration is 365 days or less"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0
expected_max_days=365

# Sprawdzenie PASS_MAX_DAYS w /etc/login.defs
max_days=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{ print $2 }')

# Sprawdzenie, czy PASS_MAX_DAYS jest poprawnie ustawiony
if [ -z "$max_days" ] || [ "$max_days" -gt $expected_max_days ]; then
    test_fail_messages+=("PASS_MAX_DAYS is more than $expected_max_days or not set. Current value: $max_days.")
    exit_status=1
fi

# Sprawdzenie maksymalnego wieku hasła dla każdego użytkownika
while IFS=':' read -r user pass max_days_rest; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ "$max_days_rest" -gt $expected_max_days ] || [ "$max_days_rest" -eq -1 ]; then
            test_fail_messages+=("User $user has PASS_MAX_DAYS more than $expected_max_days or disabled. Current value: $max_days_rest.")
            exit_status=1
            break
        fi
    fi
done < <(cut -d: -f1,2,5 /etc/shadow)

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
