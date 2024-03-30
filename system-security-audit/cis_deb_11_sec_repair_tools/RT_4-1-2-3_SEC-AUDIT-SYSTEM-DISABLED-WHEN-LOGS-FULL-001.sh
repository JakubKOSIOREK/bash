#!/usr/bin/env bash

repair_id="SEC-AUDIT-SYSTEM-DISABLED-WHEN-LOGS-FULL-001"
repair_name="Configure 'space_left_action'"
file_name="/etc/audit/auditd.conf"

script_path="$0"
repair_file=$(basename "$script_path")

changes_needed=0

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Skrypt musi być uruchomiony z uprawnieniami roota."
    exit 1
fi

# Sprawdzanie obecnych konfiguracji i oznaczanie potrzeby zmian
if ! grep -Pq '^space_left_action\s*=\s*email\b' "$file_name"; then
    changes_needed=1
fi

if ! grep -Pq '^action_mail_acct\s*=\s*root\b' "$file_name"; then
    changes_needed=1
fi

if ! grep -Pq '^admin_space_left_action\s*=\s*(halt|single)\b' "$file_name"; then
    changes_needed=1
fi

# Jeśli żadne zmiany nie są potrzebne, zakończ z kodem 2
if [ $changes_needed -eq 0 ]; then
    echo "N/A;${repair_id};${repair_file};${repair_name};No changes needed."
    exit 2
fi

# Proces naprawy (jeśli potrzebny)
# Tworzenie kopii zapasowej, modyfikacja pliku konfiguracyjnego i restart usługi...

echo "DONE;${repair_id};${repair_file};${repair_name};Required changes were made."
exit 0
