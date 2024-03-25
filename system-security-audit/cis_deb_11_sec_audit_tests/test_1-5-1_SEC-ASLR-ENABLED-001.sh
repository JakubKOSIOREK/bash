#!/bin/bash

test_id="SEC-ASLR-ENABLED-001"
test_name="Ensure address space layout randomization (ASLR) is enabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Pobranie wartości konfiguracji ASLR
aslr_value=$(cat /proc/sys/kernel/randomize_va_space)

# Sprawdzenie, czy ASLR jest włączony (wartość różna od 0; zalecane 2)
if [ "$aslr_value" != "2" ]; then
    test_fail_messages+=(" - ASLR nie jest w pełni włączony (oczekiwana wartość: 2, aktualna wartość: $aslr_value).")
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
