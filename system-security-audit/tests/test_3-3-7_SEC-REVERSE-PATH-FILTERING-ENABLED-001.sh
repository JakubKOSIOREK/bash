#!/usr/bin/env bash

test_id="SEC-REVERSE-PATH-FILTERING-ENABLED-001"
test_name="Ensure Reverse Path Filtering is enabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lista parametrów do sprawdzenia
parameters=(
    "net.ipv4.conf.all.rp_filter=1"
    "net.ipv4.conf.default.rp_filter=1"
)

# Sprawdzanie i weryfikacja ustawień
for param in "${parameters[@]}"; do
    param_name=$(echo "$param" | cut -d= -f1)
    expected_value=$(echo "$param" | cut -d= -f2)

    # Sprawdzenie aktualnej konfiguracji sysctl
    current_value=$(sysctl "$param_name" | awk '{print $3}')
    if [ "$current_value" != "$expected_value" ]; then
        test_fail_messages+=(" - Parametr $param_name jest ustawiony na $current_value zamiast $expected_value.")
        exit_status=1
    fi

    # Sprawdzanie plików konfiguracyjnych sysctl
    found_in_file=$(grep -rHs "$param_name\s*=" /etc/sysctl.conf /etc/sysctl.d/ /usr/lib/sysctl.d/ /run/sysctl.d/ 2>/dev/null | grep -vE "$param_name\s*=\s*$expected_value")
    if [ -n "$found_in_file" ]; then
        test_fail_messages+=(" - Parametr $param_name jest niepoprawnie ustawiony w pliku konfiguracyjnym.")
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status