#!/bin/bash

test_id="RSYSLOG-DEFAULT-FILE-PERM-001"
test_name="Ensure rsyslog default file permissions are configured"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach

# Sprawdzenie, czy istnieje plik konfiguracyjny rsyslog
rsyslog_conf="/etc/rsyslog.conf"
rsyslog_d_conf="/etc/rsyslog.d/*.conf"
if [ -f "$rsyslog_conf" ] || ls $rsyslog_d_conf 1>/dev/null 2>&1; then
    # Sprawdzenie, czy istnieje wpis dotyczący FileCreateMode
    if grep -q '^\$FileCreateMode' "$rsyslog_conf" $rsyslog_d_conf 2>/dev/null; then
        # Sprawdzenie, czy wpis FileCreateMode ma wartość 0640
        file_create_mode=$(grep '^\$FileCreateMode' "$rsyslog_conf" $rsyslog_d_conf 2>/dev/null | awk '{print $2}')
        if [ "$file_create_mode" != "0640" ]; then
            test_fail_messages+=("FileCreateMode nie jest ustawiony na 0640 w plikach konfiguracyjnych rsyslog.")
        fi
    else
        test_fail_messages+=("Brak wpisu FileCreateMode w plikach konfiguracyjnych rsyslog.")
    fi
else
    test_fail_messages+=("Plik konfiguracyjny rsyslog ($rsyslog_conf lub $rsyslog_d_conf) nie istnieje.")
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Sprawdzenie, czy test zakończył się sukcesem czy nie
if [ ${#test_fail_messages[@]} -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi
