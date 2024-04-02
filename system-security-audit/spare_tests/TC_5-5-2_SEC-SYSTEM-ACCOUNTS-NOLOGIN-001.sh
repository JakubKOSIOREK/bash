#!/usr/bin/env bash

test_id="SEC-SYSTEM-ACCOUNTS-NOLOGIN-001"
test_name="Ensure system accounts are secured"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Pobranie minimalnego UID z /etc/login.defs
uid_min=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Zdefiniowanie wykluczonych kont
excluded_accounts="root sync shutdown halt"

# Konwersja ciągu wykluczonych kont na tablicę
read -ra excluded_array <<< "$excluded_accounts"

# Sprawdzenie kont systemowych, które nie są ustawione na nologin lub /bin/false
while IFS=: read -r username _ _ userid _ _ shell; do
    # Pominięcie, jeżeli ID użytkownika jest wyżej niż UID_MIN lub jest na liście wykluczonych
    if (( userid >= uid_min )) || [[ " ${excluded_array[*]} " =~ " ${username} " ]]; then
        continue
    fi

    # Sprawdzenie, czy powłoka nie jest ustawiona na nologin lub /bin/false
    if [[ "$shell" != "$(which nologin)" && "$shell" != "/bin/false" ]]; then
        test_fail_messages+=("Account $username is not set to nologin or /bin/false.")
        exit_status=1
    fi
done < /etc/passwd

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
