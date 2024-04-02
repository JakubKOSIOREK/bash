#!/bin/bash

test_id="SEC-NO-NETRC-FILES-001"
test_name="Ensure no local interactive user has .netrc files"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Definiowanie maski uprawnień i maksymalnych uprawnień
perm_mask='0177'
maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
valid_shells="^($(awk 'BEGIN{ORS="|"} /^\//{print $0}' /etc/shells | sed 's/|$//'))$"

# Sprawdzanie obecności plików .netrc i ich uprawnień
while IFS=: read -r user _ uid gid _ home shell; do
    if [[ $shell =~ $valid_shells ]] && [ -d "$home" ]; then
        if [ -f "$home/.netrc" ]; then
            mode=$(stat -L -c '%a' "$home/.netrc")
            if [ "$(( 0$mode & 0$perm_mask ))" -gt 0 ]; then
                test_fail_messages+=("FAILED: User \"$user\" file: \"$home/.netrc\" is too permissive: \"$mode\" (should be: \"$maxperm\" or more restrictive)")
                exit_status=1
            else
                test_fail_messages+=("WARNING: User \"$user\" file: \"$home/.netrc\" exists and has file mode: \"$mode\"")
                # Nie zmieniamy exit_status na 1 dla ostrzeżeń
            fi
        fi
    fi
done < /etc/passwd

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=$'\n'; echo "${test_fail_messages[*]}")
    echo -e "FAIL;${test_id};${test_file};${test_name};\n$test_fail_message"
fi

exit $exit_status
