#!/usr/bin/env bash

test_id="SEC-SUDO-REAUTH-NOT-DISABLED-GLOBALLY-001"
test_name="Ensure re-authentication for privilege escalation is not disabled globally"

# Pobranie nazwy pliku skryptu
script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie dyrektyw !authenticate w plikach sudoers
authenticate_disabled_entries=$(grep -rP "^[^#]*\b!authenticate\b" /etc/sudoers /etc/sudoers.d)

if [[ -n "$authenticate_disabled_entries" ]]; then
    test_fail_messages+=(" - Znaleziono dyrektywy wyłączające wymóg ponownego uwierzytelnienia: $authenticate_disabled_entries")
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