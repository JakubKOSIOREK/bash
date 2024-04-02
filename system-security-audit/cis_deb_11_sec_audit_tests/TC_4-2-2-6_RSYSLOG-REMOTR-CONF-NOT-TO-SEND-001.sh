#!/bin/bash

test_id="RSYSLOG-REMOTE-CONF-NOT-TO-SEND-001"
test_name="Ensure rsyslog is configured to not send logs to a remote log host"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy istnieje konfiguracja przesyłania logów do zdalnego hosta
if grep -q "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null \
    || grep -qE '^\s*([^#]+\s+)?action\(([^#]+\s+)?\btarget=\"?[^#"]+\"?\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null; then
    test_fail_messages+=("Konfiguracja rsyslog do przesyłania logów do zdalnego hosta została znaleziona.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
