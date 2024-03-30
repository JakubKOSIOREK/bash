#!/usr/bin/env bash

test_id="SEC-SUDO-LOG-FILE-MODIFICATION-COLLECTED-001"
test_name="Ensure events that modify the sudo log file are collected"
exit_status=0
test_fail_messages=() # Tablica na komunikaty o błędach

script_path="$0"
test_file=$(basename "$script_path")

# Ustalanie ścieżki do pliku logu sudo
SUDO_LOG_FILE=$(grep -rE 'Defaults\s+logfile=' /etc/sudoers /etc/sudoers.d/* | head -1 | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g')

if [ -z "${SUDO_LOG_FILE}" ]; then
    SUDO_LOG_FILE="/var/log/sudo.log"
fi

# Sprawdzenie istnienia narzędzia auditctl
if ! sudo /usr/sbin/auditctl -l &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
else
    # Załadowanie reguł do zmiennej
    loaded_rules=$(sudo /usr/sbin/auditctl -l)

    # Definicja oczekiwanej reguły jako wzorca
    expected_rule="-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file"

    # Funkcja do sprawdzania obecności reguły
    function check_rule {
        local pattern="$1"
        echo "$loaded_rules" | grep -qE -- "$pattern" && return 0 || return 1
    }

    # Sprawdzanie obecności oczekiwanej reguły
    if ! check_rule "$expected_rule"; then
        test_fail_messages+=("Oczekiwana reguła audytu dla modyfikacji pliku logów sudo nie jest załadowana: $expected_rule")
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name}"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
