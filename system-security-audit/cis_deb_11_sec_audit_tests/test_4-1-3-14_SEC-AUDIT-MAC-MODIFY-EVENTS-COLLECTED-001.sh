#!/usr/bin/env bash

test_id="SEC-AUDIT-MAC-MODIFY-EVENTS-COLLECTED-001"
test_name="Ensure events that modify the system's Mandatory Access Controls are collected"
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest dostępne."
    exit 1
fi

# Katalogi AppArmor do monitorowania
directories_to_monitor=(
    "/etc/apparmor/"
    "/etc/apparmor.d/"
)

# Definicja oczekiwanej reguły audytu dla monitorowanych katalogów
expected_rule="-w DIRECTORY_PATH -p wa -k MAC-policy"

# Sprawdzanie reguł na dysku
for directory in "${directories_to_monitor[@]}"; do
    # Podmieniamy placeholder DIRECTORY_PATH na aktualną ścieżkę katalogu
    current_rule=$(echo "$expected_rule" | sed "s/DIRECTORY_PATH/$directory/")
    if ! grep -Pq -- "$(echo $current_rule | sed 's/[\&\/]/\\&/g')" /etc/audit/rules.d/*.rules 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Brak oczekiwanej reguły audytu dla katalogu: $directory."
        exit_status=1
    fi
done

# Sprawdzanie załadowanych reguł
for directory in "${directories_to_monitor[@]}"; do
    current_rule=$(echo "$expected_rule" | sed "s/DIRECTORY_PATH/$directory/")
    if ! auditctl -l | grep -Pq -- "$(echo $current_rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Oczekiwana reguła dla katalogu: $directory nie jest załadowana."
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
