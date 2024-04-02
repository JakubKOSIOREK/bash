#!/bin/bash

test_id="RSYSLOG-NOT-RECEIVE-LOGS-001"
test_name="Ensure rsyslog is not configured to receive logs from a remote client"
script_path="$0"
test_file=$(basename "$script_path")

# Sprawdzenie, czy rsyslog nie jest skonfigurowany do odbierania logów od zdalnego klienta
if grep -q '$ModLoad imtcp' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null \
    || grep -q '$InputTCPServerRun' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null \
    || grep -q -P -- '^\h*module\(load="imtcp"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null \
    || grep -q -P -- '^\h*input\(type="imtcp" port="514"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null; then
    echo "FAIL;$test_id;$test_file;$test_name;"
else
    echo "PASS;$test_id;$test_file;$test_name;"

fi
