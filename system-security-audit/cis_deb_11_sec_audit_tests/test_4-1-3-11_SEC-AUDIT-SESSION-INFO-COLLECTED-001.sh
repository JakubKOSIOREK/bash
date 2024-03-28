#!/usr/bin/env bash

test_id="SEC-AUDIT-SESSION-INFO-COLLECTED-001"
test_name="Ensure session initiation information is collected"
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest dostępne."
    exit 1
fi

# Lista plików do monitorowania
files_to_monitor=(
    "/var/run/utmp"
    "/var/log/wtmp"
    "/var/log/btmp"
)

# Definicja oczekiwanej reguły audytu dla monitorowanych plików
expected_rule="-w FILE_PATH -p wa -k session"

# Sprawdzanie reguł na dysku
for file in "${files_to_monitor[@]}"; do
    # Podmieniamy placeholder FILE_PATH na aktualną ścieżkę pliku
    current_rule=$(echo "$expected_rule" | sed "s/FILE_PATH/$file/")
    if ! grep -Pq -- "$(echo $current_rule | sed 's/[\&\/]/\\&/g')" /etc/audit/rules.d/*.rules 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Brak oczekiwanej reguły audytu dla pliku: $file."
        exit_status=1
    fi
done

# Sprawdzanie załadowanych reguł
for file in "${files_to_monitor[@]}"; do
    current_rule=$(echo "$expected_rule" | sed "s/FILE_PATH/$file/")
    if ! auditctl -l | grep -Pq -- "$(echo $current_rule | sed 's/[\&\/]/\\&/g')" 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Oczekiwana reguła dla pliku: $file nie jest załadowana."
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name; - Informacje o inicjacji sesji są poprawnie rejestrowane."
else
    exit $exit_status
fi
