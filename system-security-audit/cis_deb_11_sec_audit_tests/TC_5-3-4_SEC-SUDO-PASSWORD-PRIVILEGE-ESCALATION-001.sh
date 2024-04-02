#!/usr/bin/env bash

test_id="SEC-SUDO-PASSWORD-PRIVILEGE-ESCALATION-001"
test_name="Ensure users must provide password for privilege escalation"

# Pobranie nazwy pliku skryptu
script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie dyrektyw NOPASSWD w plikach sudoers
nopasswd_entries=$(grep -rP "^[^#]*\bNOPASSWD\b" /etc/sudoers /etc/sudoers.d)

if [[ -n "$nopasswd_entries" ]]; then
    test_fail_messages+=("- Znaleziono konfiguracje NOPASSWD w plikach sudoers: $nopasswd_entries")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
