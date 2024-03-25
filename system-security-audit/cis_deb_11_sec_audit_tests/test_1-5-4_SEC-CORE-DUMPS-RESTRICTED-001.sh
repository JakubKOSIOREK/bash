#!/bin/bash

test_id="SEC-CORE-DUMPS-RESTRICTED-001"
test_name="Ensure core dumps are restricted"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# 1. Sprawdzenie ustawień ograniczeń na zrzuty rdzenia
if ! grep -Es '^(\*|\s).*hard.*core.*(\s+#.*)?$' /etc/security/limits.conf /etc/security/limits.d/* | grep -q '0'; then
    test_fail_messages+=(" - Ograniczenie zrzutów rdzenia (core dumps) nie jest ustawione na 0.")
    exit_status=1
fi

# 2. Weryfikacja wartości fs.suid_dumpable
#if ! sysctl fs.suid_dumpable | grep -q '= 0'; then
#    test_fail_messages+=(" - Wartość fs.suid_dumpable nie jest ustawiona na 0.")
#    exit_status=1
#fi

# Sprawdzenie plików konfiguracyjnych sysctl dla fs.suid_dumpable
if ! grep -q "fs.suid_dumpable = 0" /etc/sysctl.conf /etc/sysctl.d/*; then
    test_fail_messages+=(" - Wartość fs.suid_dumpable nie jest trwale ustawiona na 0 w plikach konfiguracyjnych sysctl.")
    exit_status=1
fi

# 3. Sprawdzenie stanu usługi systemd-coredump
if systemctl is-enabled coredump.service &> /dev/null; then
    coredump_status=$(systemctl is-enabled coredump.service)
    if [[ "$coredump_status" == "enabled" || "$coredump_status" == "masked" ]]; then
        test_fail_messages+=(" - Usługa systemd-coredump jest włączona lub zablokowana.")
        exit_status=1
    fi
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;$test_id;$test_name;$test_fail_message"
else
    echo "PASS;$test_id;$test_name; - Zrzuty rdzenia są odpowiednio ograniczone."
fi

exit $exit_status
