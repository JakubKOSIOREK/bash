#!/bin/bash

test_id="AUDITD-CONFIG-RSYSLOG-001"
test_name="Ensure journald is configured to send logs to rsyslog"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

journald_conf="/etc/systemd/journald.conf"
if [ -f "$journald_conf" ]; then
    forward_status=$(grep -Po '^ForwardToSyslog=\Kyes' "$journald_conf")
    if [ "$forward_status" != "yes" ]; then
        test_fail_messages+=("ForwardToSyslog nie jest ustawiony na 'yes' w $journald_conf lub jest zakomentowany.")
        exit_status=1
    else
        exit_status=0
    fi
else
    test_fail_messages+=("Plik konfiguracyjny journald ($journald_conf) nie istnieje.")
    exit_status=1
fi

test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

if [ ${#test_fail_messages[@]} -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
