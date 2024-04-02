#!/bin/bash

test_id="SEC-USER-DOT-FILES-PERMISSIONS-001"
test_name="Ensure local interactive user dot files are not group or world writable"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Definiowanie maski uprawnień i maksymalnych uprawnień
perm_mask='0022'
maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
valid_shells="^($(awk 'BEGIN{ORS="|"} /^\//{print $0}' /etc/shells | sed 's/|$//'))$"

# Sprawdzanie uprawnień plików konfiguracyjnych w katalogach domowych
while IFS=: read -r user _ uid gid _ home shell; do
    if [[ $shell =~ $valid_shells ]] && [ -d "$home" ]; then
        while IFS= read -r dfile; do
            mode=$(stat -L -c '%a' "$dfile")
            if [ $(( 0$mode & 0$perm_mask )) -gt 0 ]; then
                test_fail_messages+=("User $user file: \"$dfile\" is too permissive: \"$mode\" (should be: \"$maxperm\" or more restrictive)")
                exit_status=1
            fi
        done < <(find "$home" -maxdepth 1 -type f -name '.*')
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
