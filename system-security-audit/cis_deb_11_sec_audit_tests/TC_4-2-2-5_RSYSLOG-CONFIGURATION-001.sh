#!/bin/bash

test_id="RSYSLOG-CONFIGURATION-001"
test_name="Ensure logging is configured"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy plik /etc/rsyslog.conf istnieje
if [ -e "/etc/rsyslog.conf" ]; then
    rsyslog_conf=true
else
    rsyslog_conf=false
    test_fail_messages+=("/etc/rsyslog.conf does not exist.")
    exit_status=1
fi

# Sprawdzenie, czy istnieją pliki konfiguracyjne w katalogu /etc/rsyslog.d/
if ls /etc/rsyslog.d/*.conf >/dev/null 2>&1; then
    rsyslog_d_conf=true
else
    rsyslog_d_conf=false
    test_fail_messages+=("No configuration files in /etc/rsyslog.d/.")
fi

# Sprawdzenie, czy test zakończył się sukcesem czy nie
if $rsyslog_conf && $rsyslog_d_conf; then
    echo "PASS;$test_id;$test_file;$test_name;"
elif $rsyslog_conf && ! $rsyslog_d_conf; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    # Tworzenie jednego komunikatu o błędzie
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
