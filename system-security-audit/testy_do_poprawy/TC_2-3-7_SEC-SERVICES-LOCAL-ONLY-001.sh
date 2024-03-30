#!/bin/bash

test_id="SEC-SERVICES-LOCAL-ONLY-001"
test_name="Ensure non-essential services are removed or masked"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lista dozwolonych usług (whitelist)
#white_list="ssh dhcp dhclient" # VM Kuba Debian 11.5 minimal
white_list="" # tu dodać usługi z TZK

# Uruchomienie polecenia ss do sprawdzenia nasłuchujących usług
listening_services=$(ss -plntu | grep -E -v '127.0.0.1|::1' | grep -v 'State')

# Filtracja usług nie znajdujących się na liście dozwolonych
for service in $white_list; do
    listening_services=$(echo "$listening_services" | grep -v "$service")
done

if [ ! -z "$listening_services" ]; then
    test_fail_messages+=(" - Znaleziono usługi nasłuchujące na nie-lokalnych adresach IP, które nie są na liście dozwolonych:\n$listening_services")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo -e "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
