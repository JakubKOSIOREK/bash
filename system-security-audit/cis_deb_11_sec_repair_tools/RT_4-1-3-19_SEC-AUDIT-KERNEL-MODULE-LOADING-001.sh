#!/usr/bin/env bash

repair_id="SEC-AUDIT-KERNEL-MODULE-LOADING-001"
repair_name="Copy kernel modules audit rules and load them"
rules="19-kernel_modules.rules"

# Ustawienie ścieżki do katalogu ze skryptami
dir_path=$(dirname "$0")
scripts_dir="$(dirname "$dir_path")/tzk_szgdk_config_files"
source_file="$scripts_dir/audit/$rules"

destination_file="/etc/audit/rules.d/$rules"

script_path="$0"
repair_file=$(basename "$script_path")

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Skrypt musi być uruchomiony z uprawnieniami roota."
    exit 1
fi

# Kopia pliku reguł
sudo cp "$source_file" "$destination_file"
if [ $? -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Nie udało się skopiować pliku reguł audytu."
    exit 1
fi

# Ponowne załadowanie reguł
sudo auditctl -R "$destination_file" &>/dev/null
if [ $? -ne 0 ]; then
    echo "ERROR;${repair_id};${repair_file};Nie udało się załadować reguł audytu."
    exit 1
fi

echo "DONE;${repair_id};${repair_file};${repair_name};Reguły audytu zostały skopiowane i załadowane."
exit 0
