#!/usr/bin/env bash

repair_id="SEC-AUDIT-LOG-SIZE-CONFIGURED-001"
repair_name="Configure audit log storage size to ${recommended_max_log_file_size}MB"
file_name="/etc/audit/auditd.conf"

recommended_max_log_file_size="8" # Zalecany rozmiar pliku loga w MB

script_path="$0"
repair_file=$(basename "$script_path")

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Skrypt musi być uruchomiony z uprawnieniami roota."
    exit 1
fi

# Sprawdzenie, czy parametr max_log_file jest skonfigurowany w pliku auditd.conf
max_log_file_configured=$(grep -Po -- '^\s*max_log_file\s*=\s*\d+\b' "$file_name")

if [[ -z "$max_log_file_configured" ]]; then
    # Tworzenie kopii zapasowej
    cp "$file_name" "${file_name}.bak"
    # Dodanie konfiguracji 'max_log_file'
    echo "max_log_file = $recommended_max_log_file_size" >> "$file_name"
    service auditd restart
    echo "DONE;${repair_id};${repair_file};${repair_name};Configured 'max_log_file=$recommended_max_log_file_size' in /etc/audit/auditd.conf."
    exit 0
else
    echo "N/A;${repair_id};${repair_file};${repair_name};Parameter 'max_log_file' is already configured."
    exit 2
fi
