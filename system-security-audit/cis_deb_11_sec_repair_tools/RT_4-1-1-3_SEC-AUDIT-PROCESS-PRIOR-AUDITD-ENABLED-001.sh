#!/usr/bin/env bash

repair_id="SEC-AUDIT-PROCESS-PRIOR-AUDITD-ENABLED-001"
repair_name="Enable auditd start-pre audit with 'audit=1' in GRUB"
file_name="/etc/default/grub"

script_path="$0"
repair_file=$(basename "$script_path")

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Skrypt musi być uruchomiony z uprawnieniami roota."
    exit 1
fi

# Sprawdzenie i naprawa konfiguracji GRUB2
if grep -Pq '^\s*GRUB_CMDLINE_LINUX' "$file_name" && ! grep -Pq '^\s*GRUB_CMDLINE_LINUX.*audit=1' "$file_name"; then
    # Tworzenie kopii zapasowej
    cp "$file_name" "${file_name}.bak"
    # Dodawanie 'audit=1' do konfiguracji
    sed -i 's/\(GRUB_CMDLINE_LINUX=".*\)"/\1 audit=1"/' "$file_name"
    update-grub
    echo "DONE;${repair_id};${repair_file};${repair_name};Dodano 'audit=1' do GRUB_CMDLINE_LINUX_DEFAULT."
    exit 0
else
    echo "N/A;${repair_id};${repair_file};${repair_name};Ustawienie 'audit=1' jest już zaimplementowane."
    exit 2
fi
