#!/bin/bash

test_id="SEC-NTP-ACCESS-CONTROL-001"
test_name="Ensure ntp access control is configured"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lokalizacja pliku konfiguracyjnego ntp
ntp_conf="/etc/ntp.conf"

# Sprawdzenie, czy ntp jest używany na systemie
if [ ! -f "$ntp_conf" ]; then
    echo "N/A;$test_id;$test_name; - ntp nie jest zainstalowany."
    exit 0
fi

# Weryfikacja linii restrict
restrict_lines=$(grep -P -- '^\s*restrict\s+((-4\s+)?|-6\s+)default\s+(?:[^\#\n\r]+\s+)*(?!(?:\2|\3|\4|\5))(\s*\bkod\b\s*|\s*\bnomodify\b\s*|\s*\bnotrap\b\s*|\s*\bnopeer\b\s*|\s*\bnoquery\b\s*)\s+(?:[^\#\n\r]+\s+)*(?!(?:\1|\3|\4|\5))(\s*\bkod\b\s*|\s*\bnomodify\b\s*|\s*\bnotrap\b\s*|\s*\bnopeer\b\s*|\s*\bnoquery\b\s*)\s+(?:[^\#\n\r]+\s+)*(?!(?:\1|\2|\4|\5))(\s*\bkod\b\s*|\s*\bnomodify\b\s*|\s*\bnotrap\b\s*|\s*\bnopeer\b\s*|\s*\bnoquery\b\s*)\s+(?:[^\#\n\r]+\s+)*(?!(?:\1|\2|\3|\5))(\s*\bkod\b\s*|\s*\bnomodify\b\s*|\s*\bnotrap\b\s*|\s*\bnopeer\b\s*|\s*\bnoquery\b\s*)\s+(?:[^\#\n\r]+\s+)*(?!(?:\1|\2|\3|\4))(\s*\bkod\b\s*|\s*\bnomodify\b\s*|\s*\bnotrap\b\s*|\s*\bnopeer\b\s*|\s*\bnoquery\b\s*)\s*(?:\s+\S+\s*)*(?:\s+#.*)?$' "$ntp_conf")

if [ -z "$restrict_lines" ]; then
    test_fail_messages+=(" - Nie znaleziono konfiguracji 'restrict' z wymaganymi flagami.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
