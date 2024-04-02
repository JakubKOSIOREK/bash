#!/usr/bin/env bash

test_id="SEC-SYSTEM-ACCOUNTS-SECURED-001"
test_name="Ensure system accounts are secured"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Lista kont wyłączonych z kontroli (root, sync, shutdown, halt są dozwolone)
excluded_accounts="root sync shutdown halt"

# Wyszukiwanie kont systemowych, które mają ustawione powłoki inne niż nologin lub false
awk_command="\
awk -F: '\$1!~/$excluded_accounts/ && \$3<$UID_MIN && \$7!~/((\\/usr)?\\/sbin\\/nologin)/ && \$7!~/(\\/bin)?\\/false/ {print}' /etc/passwd\
"

awk_result=$(eval "$awk_command")

# Dodatkowe sprawdzenie, czy konta nie są zablokowane
if [ ! -z "$awk_result" ]; then
    while IFS= read -r line; do
        user=$(echo "$line" | cut -d: -f1)
        locked_status=$(passwd -S "$user" | awk '{print $2}')
        if [ "$locked_status" != "LK" ] && [ "$locked_status" != "NP" ]; then
            test_fail_messages+=("Account $user is not locked or does not have nologin/false shell.")
            exit_status=1
        fi
    done <<< "$awk_result"
fi

# Sprawdzenie, czy znaleziono jakiekolwiek niezabezpieczone konta systemowe
if [ ${#test_fail_messages[@]} -gt 0 ]; then
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_file;$test_name;"
fi

exit $exit_status
