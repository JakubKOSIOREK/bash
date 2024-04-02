#!/usr/bin/env bash

test_id="SEC-PASSWORD-CHANGE-PAST-001"
test_name="Ensure all users' last password change date is in the past"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie daty ostatniej zmiany hasła dla każdego użytkownika
for user in $(cut -d: -f1 /etc/shadow); do
    last_pw_change=$(chage --list "$user" | grep '^Last password change' | cut -d: -f2)
    if [[ -n "$last_pw_change" ]]; then
        last_pw_change_date=$(date -d "$last_pw_change" +%s)
        current_date=$(date +%s)

        if [[ $last_pw_change_date -gt $current_date ]]; then
            test_fail_messages+=("User $user has last password change date in the future: $last_pw_change")
            exit_status=1
        fi
    fi
done

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
