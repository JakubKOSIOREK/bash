#!/bin/bash

# Ścieżka do pliku konfiguracyjnego
config_file="/etc/audit/auditd.conf"

# Sprawdzenie, czy plik istnieje
if [ ! -f "$config_file" ]; then
    echo "Plik konfiguracyjny $config_file nie istnieje."
    exit 1
fi

# Zmiana wartości 'max_log_file_action'
sudo sed -i '/^max_log_file_action/ c\max_log_file_action = keep_logs' "$config_file"

# Sprawdzenie, czy polecenie się powiodło
if grep -q "^max_log_file_action = keep_logs" "$config_file"; then
    echo "Pomyślnie zmieniono 'max_log_file_action' na 'keep_logs'."
else
    echo "Nie udało się zmienić wartości 'max_log_file_action'."
fi

# Przeładowanie usługi auditd, aby zmiany weszły w życie
sudo systemctl reload auditd
echo "Usługa auditd została przeładowana."
