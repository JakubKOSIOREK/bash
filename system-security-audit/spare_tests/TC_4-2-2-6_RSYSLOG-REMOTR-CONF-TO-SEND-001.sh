#!/bin/bash

test_id="RSYSLOG-REMOTR-CONF-TO-SEND-001"
test_name="Ensure rsyslog is configured to send logs to a remote log 
host"
script_path="$0"
test_file=$(basename "$script_path")

# Sprawdzenie, czy istnieje konfiguracja przesyłania logów do zdalnego hosta
if grep -q "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null \
    || grep -qE '^\s*([^#]+\s+)?action\(([^#]+\s+)?\btarget=\"?[^#"]+\"?\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;"
fi
