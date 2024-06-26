#!/bin/bash

test_id="SEC-APPARMOR-ENABLED-IN-BOOTLOADER-001"
test_name="Ensure AppArmor is enabled in the bootloader configuration"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie parametrów apparmor=1 w konfiguracji GRUB
if ! grep -q "^\s*linux" /boot/grub/grub.cfg | grep "apparmor=1" &> /dev/null; then
    test_fail_messages+=("Brak parametru 'apparmor=1' w niektórych wpisach GRUB.")
    exit_status=1
fi

# Sprawdzenie parametrów security=apparmor w konfiguracji GRUB
if ! grep -q "^\s*linux" /boot/grub/grub.cfg | grep "security=apparmor" &> /dev/null; then
    test_fail_messages+=("Brak parametru 'security=apparmor' w niektórych wpisach GRUB.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
else
    echo "PASS;${test_id};${test_file};${test_name};"
fi

exit $exit_status
