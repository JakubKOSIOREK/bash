#!/usr/bin/env bash

test_id="SEC-AUDIT-LOGIN-LOGOUT-EVENTS-COLLECTED-001"
test_name="Ensure login and logout events are collected"
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest dostępne."
    exit 1
fi

# Lista plików i katalogów do monitorowania
files_to_monitor=(
    "/var/log/lastlog"
    "/var/run/faillock"
)

# Definicja oczekiwanej reguły audytu dla monitorowanych plików i katalogów
expected_rule="-w FILE_PATH -p wa -k logins"

# Sprawdzanie reguł na dysku
for file in "${files_to_monitor[@]}"; do
    # Podmieniamy placeholder FILE_PATH na aktualną ścieżkę pliku/katalogu
    current_rule=$(echo "$expected_rule" | sed "s/FILE_PATH/$file/")
    if ! grep -Pq -- "$(echo $current_rule | sed 's/[\&\/]/\\&/g')" /etc/audit/rules.d/*.rules 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Brak oczekiwanej reguły audytu dla: $file."
        exit_status=1
    fi
done

# Sprawdzanie załadowanych reguł
for file in "${files_to_monitor[@]}"; do
    current_rule=$(echo "$expected_rule" | sed "s/FILE_PATH/$file/")
    if ! auditctl -l | grep -Pq -- "$(echo $current_rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Oczekiwana reguła dla: $file nie jest załadowana."
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
