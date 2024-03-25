#!/bin/bash

test_id="SEC-APPARMOR-INSTALLED-001"
test_name="Ensure AppArmor is installed"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lista pakietów do sprawdzenia
packages=("apparmor" "apparmor-utils")

# Pętla przez wszystkie pakiety i sprawdzenie ich statusu
for pkg in "${packages[@]}"; do
    if ! dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' $pkg 2>/dev/null | grep -q "install ok installed"; then
        test_fail_messages+=(" - Pakiet $pkg nie jest zainstalowany.")
        exit_status=1
    fi
done

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
