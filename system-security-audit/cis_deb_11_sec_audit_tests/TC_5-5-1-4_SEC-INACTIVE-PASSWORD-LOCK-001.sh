#!/usr/bin/env bash

test_id="SEC-INACTIVE-PASSWORD-LOCK-001"
test_name="Ensure inactive password lock is 30 days or less"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0
expected_inactive_days=30

# Sprawdzenie domyślnego ustawienia INACTIVE dla systemu
inactive_default=$(useradd -D | grep INACTIVE | cut -d= -f2)

# Sprawdzenie, czy domyślne ustawienie INACTIVE dla systemu wynosi 30 dni lub mniej
if [ -z "$inactive_default" ] || [ "$inactive_default" -gt $expected_inactive_days ]; then
    test_fail_messages+=("System default INACTIVE is more than $expected_inactive_days days or not set. Current value: $inactive_default.")
    exit_status=1
fi

# Sprawdzenie ustawienia INACTIVE dla każdego użytkownika
while IFS=':' read -r user pass inactive_days; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ -z "$inactive_days" ] || [ "$inactive_days" -gt $expected_inactive_days ]; then
            test_fail_messages+=("User $user has INACTIVE setting more than $expected_inactive_days days or not set. Current value: $inactive_days.")
            exit_status=1
        fi
    fi
done < <(cut -d: -f1,2,7 /etc/shadow)

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
