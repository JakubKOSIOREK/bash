#!/bin/bash

test_id="SEC-USER-HOME-DIRS-PERMISSIONS-001"
test_name="Ensure local interactive user home directories are mode 750 or more restrictive"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Definiowanie maski uprawnień i maksymalnych uprawnień
perm_mask='0027'
maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
valid_shells="^($(awk 'BEGIN{ORS="|"} /^\//{print $0}' /etc/shells | sed 's/|$//'))$"

# Sprawdzanie uprawnień katalogów domowych
while IFS=: read -r user _ uid gid _ home shell; do
    if [[ $shell =~ $valid_shells ]] && [ -d "$home" ]; then
        mode=$(stat -L -c '%a' "$home")
        if [ "$(( 0$mode & 0$perm_mask ))" -gt 0 ]; then
            test_fail_messages+=("User $user home directory: \"$home\" is too permissive: \"$mode\" (should be: \"$maxperm\" or more restrictive)")
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
