#!/bin/bash

test_id="SEC-SYSTEMD-TIMESYNCD-CONF-001"
test_name="Ensure systemd-timesyncd configured with authorized timeserver"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy systemd-timesyncd jest używany na systemie
if ! systemctl is-enabled systemd-timesyncd &> /dev/null; then
    echo "N/A;$test_id;$test_name; - systemd-timesyncd nie jest włączony."
    exit 0
fi

# Wyszukiwanie konfiguracji NTP i FallbackNTP
ntp_config=$(find /etc/systemd -type f -name '*.conf' -exec grep -Ph '^\s*(NTP|FallbackNTP)=\S+' {} +)

if [ -z "$ntp_config" ]; then
    test_fail_messages+=("Brak konfiguracji NTP lub FallbackNTP.")
    exit_status=1
else
    echo "Znaleziono konfigurację NTP/FallbackNTP:"
    echo "$ntp_config"
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
