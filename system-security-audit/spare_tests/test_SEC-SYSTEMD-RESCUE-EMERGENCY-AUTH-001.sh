#!/bin/bash

test_id="SEC-SYSTEMD-RESCUE-EMERGENCY-AUTH-001"
test_name="Ensure authentication is required for rescue and emergency modes"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie przesłonięć dla rescue.service
if [ ! -f /etc/systemd/system/rescue.service.d/override.conf ]; then
    test_fail_messages+=(" - Brak przesłonięcia dla rescue.service, co może oznaczać brak dodatkowej konfiguracji wymagającej uwierzytelnienia.")
    exit_status=1
fi

# Sprawdzenie przesłonięć dla emergency.service
if [ ! -f /etc/systemd/system/emergency.service.d/override.conf ]; then
    test_fail_messages+=(" - Brak przesłonięcia dla emergency.service, co może oznaczać brak dodatkowej konfiguracji wymagającej uwierzytelnienia.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
