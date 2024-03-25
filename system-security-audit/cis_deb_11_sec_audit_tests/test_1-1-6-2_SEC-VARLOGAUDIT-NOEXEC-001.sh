#!/bin/bash

test_id="SEC-VARLOGAUDIT-NOEXEC-001"
test_name="Ensure noexec option set on /var/log/audit partition"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy opcja noexec jest ustawiona na partycji /var/log/audit
if mount | grep ' on /var/log/audit ' | grep -q 'noexec'; then
    echo "PASS;$test_id;$test_name;"
    exit 0
else
    test_fail_messages+=(" - Opcja noexec nie jest ustawiona na partycji /var/log/audit.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
echo "FAIL;$test_id;$test_name;$test_fail_message"

exit $exit_status
