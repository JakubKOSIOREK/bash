#!/bin/bash

test_id="SEC-SYSTEMD-TIMESYNCD-CONF-001"
test_name="Ensure systemd-timesyncd configured with authorized timeserver"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy systemd-timesyncd jest używany na systemie
if ! systemctl is-enabled systemd-timesyncd &> /dev/null; then
    echo "N/A;${test_id};${test_file};${test_name};'systemd-timesyncd' nie jest włączony."
    exit 0
fi

# Wyszukiwanie konfiguracji NTP i FallbackNTP
ntp_config=$(grep -Ph '^\s*(NTP|FallbackNTP)=\S+' /etc/systemd/timesyncd.conf)

if [ -z "$ntp_config" ]; then
    test_fail_messages+=("Brak konfiguracji NTP lub FallbackNTP.")
    exit_status=1
fi

# Raportowanie wyniku tylko jeśli test się nie powiódł
if [ $exit_status -ne 0 ]; then
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
