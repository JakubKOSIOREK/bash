#!/usr/bin/env bash

test_id="SEC-PASSWORD-MIN-DAYS-001"
test_name="Ensure minimum days between password changes is configured"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0
expected_min_days=1

# Sprawdzenie PASS_MIN_DAYS w /etc/login.defs
min_days=$(grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{ print $2 }')

# Sprawdzenie, czy PASS_MIN_DAYS jest poprawnie ustawiony
if [ -z "$min_days" ] || [ "$min_days" -lt "$expected_min_days" ]; then
    test_fail_messages+=("PASS_MIN_DAYS is less than $expected_min_days or not set. Current value: $min_days.")
    exit_status=1
fi

# Sprawdzenie minimalnego wieku hasła dla każdego użytkownika
while IFS=':' read -r user pass min_days_rest; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ "$min_days_rest" -lt "$expected_min_days" ]; then
            test_fail_messages+=("User $user has PASS_MIN_DAYS less than $expected_min_days. Current value: $min_days_rest.")
            exit_status=1
            break
        fi
    fi
done < <(cut -d: -f1,2,4 /etc/shadow)

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
