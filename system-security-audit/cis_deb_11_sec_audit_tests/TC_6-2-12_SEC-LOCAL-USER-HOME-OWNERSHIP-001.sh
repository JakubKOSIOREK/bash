#!/bin/bash

test_id="SEC-LOCAL-USER-HOME-OWNERSHIP-001"
test_name="Ensure local interactive users own their home directories"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Budowanie wzorca dopasowującego tylko prawidłowe powłoki
valid_shells="^($(awk 'BEGIN{ORS="|"} /^\//{print $0}' /etc/shells | sed 's/|$//'))$"

# Sprawdzanie, czy użytkownicy są właścicielami swoich katalogów domowych
while IFS=: read -r user _ uid gid _ home shell; do
    if [[ $shell =~ $valid_shells ]] && [ -d "$home" ]; then
        owner="$(stat -L -c "%U" "$home")"
        if [ "$owner" != "$user" ]; then
            test_fail_messages+=("User \"$user\" home directory \"$home\" is owned by \"$owner\"")
            exit_status=1
        fi
    fi
done < /etc/passwd

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};Wrong home directory ownerships:$test_fail_message"
fi

exit $exit_status
