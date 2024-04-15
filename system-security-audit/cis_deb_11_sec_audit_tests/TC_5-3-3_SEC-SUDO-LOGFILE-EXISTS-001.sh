#!/usr/bin/env bash

test_id="SEC-SUDO-LOGFILE-EXISTS-001"
test_name="Ensure sudo log file exists"

# Pobranie nazwy pliku skryptu
script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie dyrektywy Defaults logfile w plikach sudoers
logfile_entry=$(grep -rPsi "^\s*Defaults\s+([^#]+,\s*)?logfile\s*=\s*(\"|')?\S+(\"|')?(\s*,\s*\S+\s*)*\s*(#.*)?$" /etc/sudoers /etc/sudoers.d)

if [[ -z "$logfile_entry" ]]; then
    test_fail_messages+=(" - Nie znaleziono dyrektywy 'Defaults logfile' w plikach konfiguracyjnych sudo.")
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
