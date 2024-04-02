#!/bin/bash

test_id="SEC-NO-FORWARD-FILES-001"
test_name="Ensure no local interactive user has .forward files"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Budowanie wzorca dopasowującego tylko prawidłowe powłoki
valid_shells="^($(awk 'BEGIN{ORS="|"} /^\//{print $0}' /etc/shells | sed 's/|$//'))$"

# Sprawdzanie obecności plików .forward w katalogach domowych użytkowników
while IFS=: read -r user _ uid gid _ home shell; do
    if [[ $shell =~ $valid_shells ]] && [ -d "$home" ]; then
        if [ -f "$home/.forward" ]; then
            test_fail_messages+=("User \"$user\" has a .forward file: \"$home/.forward\"")
            exit_status=1
        fi
    fi
done < /etc/passwd

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
