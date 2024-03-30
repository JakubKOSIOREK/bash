#!/bin/bash

test_id="SEC-XDMCP-DISABLED-001"
test_name="Ensure XDCMP is not enabled"
test_fail_messages=() # Tablica na komunikaty o błędach

# Pobranie ścieżki do skryptu i nazwy pliku
script_path="$0"
test_file=$(basename "$script_path")

exit_status=0

# Ścieżka do pliku konfiguracyjnego GDM
gdm_config_file="/etc/gdm3/custom.conf"

# Sprawdzenie, czy GDM jest zainstalowany
if [ ! -f "$gdm_config_file" ]; then
    echo "PASS;$test_id;$test_file;$test_name; - GDM nie jest zainstalowany."
    exit 0
fi

# Sprawdzenie, czy XDMCP jest wyłączony
if grep -Eis '^\s*Enable\s*=\s*true' "$gdm_config_file"; then
    test_fail_messages+=("XDMCP jest włączony w $gdm_config_file.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_file;$test_name;"
fi

exit $exit_status
