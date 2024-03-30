#!/usr/bin/env bash

repair_id="SEC-AUDIT-LOG-NOT-AUTO-DELETED-001"
repair_name="# Configure 'max_log_file_action=keep_logs'
"
file_name="/etc/audit/auditd.conf"

script_path="$0"
repair_file=$(basename "$script_path")

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Skrypt musi być uruchomiony z uprawnieniami roota."
    exit 1
fi

# Sprawdzenie, czy ustawienie 'max_log_file_action' jest poprawnie skonfigurowane
if grep -Pq '^max_log_file_action\s*=\s*keep_logs\b' "$file_name"; then
    echo "N/A;${repair_id};${repair_file};${repair_name};Ustawienie 'max_log_file_action' jest już poprawnie skonfigurowane."
    exit 2
else
    # Tworzenie kopii zapasowej
    cp "$file_name" "${file_name}.bak"

    # Sprawdzenie, czy istnieje już jakieś ustawienie 'max_log_file_action' i jego modyfikacja lub dodanie
    if grep -Pq '^max_log_file_action' "$file_name"; then
        sed -i 's/^max_log_file_action.*/max_log_file_action = keep_logs/' "$file_name"
    else
        echo 'max_log_file_action = keep_logs' >> "$file_name"
    fi

    # Restart usługi auditd, aby zmiany zostały wprowadzone
    service auditd restart
    
    echo "DONE;${repair_id};${repair_file};${repair_name};Ustawiono 'max_log_file_action=keep_logs'."
    exit 0
fi
