#!/usr/bin/env bash

test_id="SEC-SUDO-USE-PTY-001"
test_name="Ensure sudo commands use pty"

# Pobranie nazwy pliku skryptu
script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie dyrektywy Defaults use_pty w plikach sudoers
sudoers_files=$(grep -rPl '^\s*Defaults\s+([^#\n\r]+,)?use_pty(,\s*\S+\s*)*\s*(#.*)?$' /etc/sudoers /etc/sudoers.d)

if [[ -z "$sudoers_files" ]]; then
    test_fail_messages+=(" - Dyrektywa 'Defaults use_pty' nie została znaleziona w plikach konfiguracyjnych sudo.")
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