#!/bin/bash

test_id="SEC-X-WINDOWS-NOT-INSTALLED-001"
test_name="Ensure X Window System is not installed"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lista pakietów do sprawdzenia - można dostosować do potrzeb
packages_to_check="xserver-xorg*"

# Lista wykluczonych pakietów
excluded_packages="xserver-xorg-core xserver-xorg-driver-all"

# Weryfikacja, czy żadne z pakietów nie są zainstalowane
installed_packages=$(dpkg-query -W -f='${binary:Package}\n' $packages_to_check 2>/dev/null | grep -v 'no packages found matching')
for package in $installed_packages; do
    if ! echo "$excluded_packages" | grep -qw "$package"; then
        if dpkg-query -W -f='${Status}\n' $package 2>/dev/null | grep -qi 'installed'; then
            # Dodawanie do listy unikalnych zainstalowanych pakietów
            if [[ ! " ${test_fail_messages[@]} " =~ " $package " ]]; then
                test_fail_messages+=("$package")
            fi
            exit_status=1
        fi
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=', '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name; - Znaleziono zainstalowane pakiety: $test_fail_message"
fi

exit $exit_status
