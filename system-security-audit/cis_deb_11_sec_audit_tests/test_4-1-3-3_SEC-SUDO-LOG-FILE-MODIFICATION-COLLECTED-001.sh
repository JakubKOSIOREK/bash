#!/usr/bin/env bash

test_id="SEC-SUDO-LOG-FILE-MODIFICATION-COLLECTED-001"
test_name="Ensure events that modify the sudo log file are collected"
exit_status=0

# Ustalanie ścieżki do pliku logu sudo
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g')

if [ -z "${SUDO_LOG_FILE}" ]; then
    SUDO_LOG_FILE="/var/log/sudo.log"
fi

SUDO_LOG_FILE_ESCAPED=$(echo "${SUDO_LOG_FILE}" | sed 's|/|\\/|g')

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest zainstalowane."
    exit 1
fi

# Sprawdzanie konfiguracji na dysku
disk_config=$(awk "/^\s*-w\s+${SUDO_LOG_FILE_ESCAPED}\s+-p\s+wa\s+/ && (/\s+key=\s*\S+\s*$/ || /\s+-k\s+\S+\s*$/)" /etc/audit/rules.d/*.rules)

# Sprawdzanie załadowanej konfiguracji
loaded_config=$(auditctl -l | grep -P "^-w\s+${SUDO_LOG_FILE}\s+-p\s+wa\s+")

# Weryfikacja konfiguracji na dysku
if [[ -z "$disk_config" ]]; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla modyfikacji pliku logów sudo nie są odpowiednio skonfigurowane na dysku."
    exit_status=1
fi

# Weryfikacja załadowanej konfiguracji
if [[ -z "$loaded_config" ]]; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla modyfikacji pliku logów sudo nie są odpowiednio skonfigurowane w załadowanej konfiguracji."
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name; - Zdarzenia modyfikujące plik logów sudo są poprawnie rejestrowane."
else
    exit $exit_status
fi
