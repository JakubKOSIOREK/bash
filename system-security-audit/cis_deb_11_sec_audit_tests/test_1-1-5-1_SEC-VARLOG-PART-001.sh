#!/bin/bash

test_id="SEC-VARLOG-PART-001"
test_name="Ensure separate partition exists for /var/log"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy /var/log jest zamontowany jako osobna partycja
if findmnt --kernel /var/log > /dev/null; then
    echo "PASS;$test_id;$test_name;"
    exit 0
else
    test_fail_messages+=(" - /var/log nie jest zamontowany jako osobna partycja.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
echo "FAIL;$test_id;$test_name;$test_fail_message"

exit $exit_status
