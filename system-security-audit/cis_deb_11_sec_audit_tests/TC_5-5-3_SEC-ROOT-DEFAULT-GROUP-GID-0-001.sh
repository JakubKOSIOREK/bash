#!/usr/bin/env bash

test_id="SEC-ROOT-DEFAULT-GROUP-GID-0-001"
test_name="Ensure default group for the root account is GID 0"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Get the current GID of the root user
current_gid=$(grep "^root:" /etc/passwd | cut -f4 -d:)

# Check if the current GID is 0
if [ "$current_gid" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_messages+=("The default group for root is not GID 0. Current GID: $current_gid")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
