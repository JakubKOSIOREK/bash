#!/bin/bash

test_id="SEC-IMAPPOP3-SERVER-NOT-INSTALLED-001"
test_name="Ensure IMAP and POP3 server are not installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Lista pakietów do sprawdzenia - można dostosować do potrzeb
packages_to_check="dovecot-imapd dovecot-pop3d"

# Weryfikacja, czy żadne z pakietów nie są zainstalowane
if dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' $packages_to_check 2>/dev/null | grep -Pi '\h+installed\b'; then
    installed_packages=$(dpkg-query -W -f='${binary:Package}\n' $packages_to_check | grep -v 'no packages found matching')
    test_fail_messages+=("Znaleziono zainstalowane pakiety: $installed_packages")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
