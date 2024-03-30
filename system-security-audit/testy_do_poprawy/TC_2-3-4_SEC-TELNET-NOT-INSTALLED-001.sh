#!/bin/bash

test_id="SEC-TELNET-NOT-INSTALLED-001"
test_name="Ensure Telnet Client are not installed"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lista pakietów do sprawdzenia - można dostosować do potrzeb
packages_to_check="telnet"

# Weryfikacja, czy żadne z pakietów nie są zainstalowane
# Weryfikacja, czy żadne z pakietów nie są zainstalowane
installed_packages=$(dpkg-query -W -f='${binary:Package}\n' $packages_to_check 2>/dev/null | grep -Pi '\h+installed\b' | cut -f1)
if [ ! -z "$installed_packages" ]; then
    test_fail_messages+=(" - Znaleziono zainstalowane pakiety: $installed_packages")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"

fi

exit $exit_status
