#!/bin/bash

test_id="SEC-SERV-AUTOFS-OFF-001"
test_name="Ensure autofs service is disabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy usługa autofs jest wyłączona
if systemctl is-enabled autofs &> /dev/null; then
    if [ "$(systemctl is-enabled autofs)" == "disabled" ] || [ "$(systemctl is-enabled autofs)" == "masked" ]; then
        echo "PASS;$test_id;$test_name;"
        exit 0
    else
        test_fail_messages+=(" - Usługa autofs nie jest wyłączona.")
        exit_status=1
    fi
else
    echo "PASS;$test_id;$test_name;"
    exit 0
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
echo "FAIL;$test_id;$test_name;$test_fail_message"

exit $exit_status