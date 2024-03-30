#!/usr/bin/env bash

repair_id="SEC-AUDIT-BACKLOG-LIMIT-ENABLED-001"
audit_backlog_limit="8192" # Recommended size for N
repair_name="Enable audit_backlog_limit=${audit_backlog_limit}"
file_name="/etc/default/grub"

script_path="$0"
repair_file=$(basename "$script_path")

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Skrypt musi być uruchomiony z uprawnieniami roota."
    exit 1
fi

# Sprawdzenie czy parametr audit_backlog_limit jest włączony w pliku konfiguracyjnym GRUB
if grep -Pq '^\s*GRUB_CMDLINE_LINUX' "$file_name" && ! grep -Pq "^\s*GRUB_CMDLINE_LINUX.*audit_backlog_limit=$audit_backlog_limit\b" "$file_name"; then
    # Tworzenie kopii zapasowej
    cp "$file_name" "${file_name}.bak"
    # Dodanie audit_backlog_limit do konfiguracji
    sed -i "s/\(GRUB_CMDLINE_LINUX=\"[^\"]*\)\"/\1 audit_backlog_limit=$audit_backlog_limit\"/" "$file_name"
    update-grub
    echo "DONE;${repair_id};${repair_file};${repair_name};Enabled 'audit_backlog_limit=$audit_backlog_limit' in GRUB_CMDLINE_LINUX."
    exit 0
else
    echo "N/A;${repair_id};${repair_file};${repair_name};Parameter 'audit_backlog_limit=$audit_backlog_limit' is already enabled or not required."
    exit 2
fi
