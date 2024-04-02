#!/bin/bash

test_id="SEC-SHADOW-GROUP-EMPTY-001"
test_name="Ensure shadow group is empty"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy w grupie shadow są jakieś konta (w /etc/group)
shadow_group_members=$(awk -F: '($1=="shadow") {print $NF}' /etc/group)

# Sprawdzenie, czy jakiekolwiek konto użytkownika ma ustawioną grupę shadow jako domyślną (w /etc/passwd)
GID=$(awk -F: '($1=="shadow") {print $3}' /etc/group)
shadow_gid_users=$(awk -F: -v GID="$GID" '($4==GID) {print $1}' /etc/passwd)

# Dodanie wyników do komunikatów o błędach, jeśli zostały znalezione
if [ -n "$shadow_group_members" ]; then
    test_fail_messages+=("$shadow_group_members")
    exit_status=1
fi

if [ -n "$shadow_gid_users" ]; then
    test_fail_messages+=("$shadow_gid_users")
    exit_status=1
fi

# Kompilacja i wyświetlanie komunikatów o błędach
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
