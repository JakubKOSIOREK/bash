#!/usr/bin/env bash

test_id="SEC-USER-PASSWORD-CHANGE-PAST-001"
test_name="Ensure all users last password change date is in the past"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Pętla przez wszystkich użytkowników z hasłami w /etc/shadow
awk -F: '/^[^:]+:[^!*]/ {print $1}' /etc/shadow | while read -r usr; do
    # Pobranie daty ostatniej zmiany hasła
    change_date=$(chage --list "$usr" | grep '^Last password change' | cut -d: -f2)
    # Sprawdzenie, czy data zmiany hasła nie jest ustawiona na "never"
    if [[ "$change_date" != "never" ]]; then
        change=$(date -d "$change_date" +%s)
        current_date=$(date +%s)
        # Sprawdzenie, czy data zmiany hasła jest w przyszłości
        if [[ "$change" -gt "$current_date" ]]; then
            test_fail_messages+=("User: \"$usr\" last password change was \"$change_date\" which is in the future.")
            exit_status=1
        fi
    fi
done

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
