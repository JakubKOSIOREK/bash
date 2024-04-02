#!/bin/bash

test_id="SEC-USB-DISABLED-001"
test_name="Ensure USB storage is disabled"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

module_name="usb-storage"

# Sprawdzenie, czy moduł jest możliwy do załadowania
module_loadable=$(modprobe -n -v $module_name 2>/dev/null)
if echo "$module_loadable" | grep -Pq -- '^\s*install \/bin\/(true|false)'; then
    test_fail_messages+=("Moduł '$module_name' nie jest możliwy do załadowania: $module_loadable")
else
    test_fail_messages+=("Moduł '$module_name' jest możliwy do załadowania: $module_loadable")
    exit_status=1
fi

# Sprawdzenie, czy moduł jest aktualnie załadowany
if ! lsmod | grep -q "$module_name"; then
    test_fail_messages+=("Moduł '$module_name' nie jest załadowany.")
else
    test_fail_messages+=("Moduł '$module_name' jest załadowany.")
    exit_status=1
fi

# Sprawdzenie, czy moduł jest na czarnej liście
if [ -d /etc/modprobe.d/ ]; then
    if grep -Pq -- "^\s*blacklist\s+$module_name\b" /etc/modprobe.d/* 2>/dev/null; then
        blacklist_files=$(grep -Pl -- "^\s*blacklist\s+$module_name\b" /etc/modprobe.d/* 2>/dev/null)
        test_fail_messages+=("Moduł '$module_name' jest na czarnej liście w: $blacklist_files")
    else
        test_fail_messages+=("Moduł '$module_name' nie jest na czarnej liście.")
        exit_status=1
    fi
else
    test_fail_messages+=("Katalog /etc/modprobe.d/ nie istnieje.")
fi

# Tworzenie komunikatu o błędach
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
