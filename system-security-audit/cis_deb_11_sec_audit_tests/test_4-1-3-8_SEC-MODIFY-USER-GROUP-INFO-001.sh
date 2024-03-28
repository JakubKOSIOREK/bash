#!/usr/bin/env bash

test_id="SEC-MODIFY-USER-GROUP-INFO-001"
test_name="Ensure events that modify user/group information are collected"
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest dostępne."
    exit 1
fi

# Lista plików do monitorowania
files_to_monitor=(
    "/etc/group"
    "/etc/passwd"
    "/etc/gshadow"
    "/etc/shadow"
    "/etc/security/opasswd"
)

# Sprawdzanie reguł na dysku
for file in "${files_to_monitor[@]}"; do
    if ! grep -Pq -- "^\s*-w\s+$file\s+-p\s+wa\s+-k\s+identity" /etc/audit/rules.d/*.rules 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Nie znaleziono reguły audytu dla pliku $file w konfiguracji na dysku."
        exit_status=1
    fi
done

# Sprawdzanie załadowanych reguł
for file in "${files_to_monitor[@]}"; do
    if ! auditctl -l | grep -Pq -- "^\s*-w\s+$file\s+-p\s+wa\s+-k\s+identity" 2>/dev/null; then
        echo "FAIL;$test_id;$test_name; - Reguła dla pliku $file nie jest załadowana."
        exit_status=1
    fi
done

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name; - Zdarzenia modyfikujące informacje o użytkownikach/grupach są poprawnie rejestrowane."
else
    exit $exit_status
fi
