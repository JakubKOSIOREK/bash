#!/bin/bash

test_id="SEC-USB-DISABLED-001"
test_name="Ensure USB storage is disabled"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie, czy moduł usb_storage jest załadowany lub zablokowany
if lsmod | grep -qE 'usb_storage|usb-storage'; then
    # Dodatkowe sprawdzenie, czy moduł jest zablokowany, a nie tylko załadowany
    if [ -n "$(grep -E 'blacklist usb-storage|install usb_storage /bin/true' /etc/modprobe.d/*)" ]; then
        echo "PASS;${test_id};${test_file};${test_name};"
        exit 0
    else
        test_fail_messages+=("Moduł usb_storage jest załadowany.")
        exit_status=1
    fi
else
    echo "PASS;${test_id};${test_file};${test_name};"
    exit 0
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
fi

exit $exit_status
