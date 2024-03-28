#!/bin/bash

test_id="SEC-SINGLE-USER-MODE-AUTH-REQUIRED-001"
test_name="Ensure authentication required for single user mode"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie, czy ustawiono superużytkownika GRUB
superusers=$(grep "^set superusers" /boot/grub/grub.cfg)

# Sprawdzenie, czy ustawiono hasło PBKDF2 dla GRUB
password_pbkdf2=$(grep "^password_pbkdf2" /boot/grub/grub.cfg)

if [[ -z "$superusers" ]]; then
    test_fail_messages+=(" - Nie ustawiono superużytkownika GRUB.")
    exit_status=1
fi

if [[ -z "$password_pbkdf2" ]]; then
    test_fail_messages+=(" - Nie ustawiono zaszyfrowanego hasła dla GRUB.")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_name;"
fi

exit $exit_status
