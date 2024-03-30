#!/bin/bash

repair_id="SEC-AUDIT-CONFIG-SYNC-FIX-001"
repair_name="Synchronize audit configuration between running and on-disk settings"

script_path="$0"
repair_file=$(basename "$script_path")

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Skrypt musi być uruchomiony z uprawnieniami roota."
    exit 1
fi

# Sprawdzenie, czy narzędzie augenrules jest dostępne
if ! command -v augenrules &> /dev/null; then
    echo "ERROR;$repair_id;$repair_name; - Narzędzie augenrules nie jest dostępne."
    exit 1
fi

# Wykonanie augenrules --check do sprawdzenia konfiguracji
check_result=$(augenrules --check 2>&1)

if [[ $check_result == *'No change'* ]]; then
    echo "N/A;$repair_id;$repair_name; - Konfiguracja audytu na dysku jest zsynchronizowana z bieżącą."
    exit 2
else
    # Ładowanie reguł
    augenrules --load

    # Sprawdzenie, czy restart jest wymagany
    if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
        echo "REBOOT REQUIRED;${repair_id};${repair_file};${repair_name};Wymagany restart, aby w pełni zastosować zmiany."
        exit 0
    else
        echo "DONE;${repair_id};${repair_file};${repair_name};Zmiany zastosowane pomyślnie, restart nie jest wymagany."
        exit 0
    fi
fi
