#!/usr/bin/env bash

test_id="SEC-SUDOERS-SCOPE-CHANGE-COLLECTED-002"
test_name="Ensure changes to system administration scope (sudoers) is collected"
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest zainstalowane."
    exit 1
fi

# Sprawdzenie, czy katalog /etc/audit/rules.d/ istnieje
if [ ! -d "/etc/audit/rules.d/" ]; then
    echo "FAIL;$test_id;$test_name; - Katalog /etc/audit/rules.d/ nie istnieje."
    exit 1
fi

# Sprawdzanie konfiguracji na dysku
if ! awk '/^\s*-w/ && /\/etc\/sudoers(\.d)?/ && /\s+-p\s+wa\s+/ && (/\s+key=\s*\S+$/ || /\s+-k\s+\S+$)/' /etc/audit/rules.d/*.rules &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla /etc/sudoers lub /etc/sudoers.d nie są odpowiednio skonfigurowane na dysku."
    exit_status=1
fi

# Sprawdzanie załadowanej konfiguracji
if ! auditctl -l | awk '/^\s*-w/ && /\/etc\/sudoers(\.d)?/ && /\s+-p\s+wa\s+/ && (/\s+key=\s*\S+$/ || /\s+-k\s+\S+$)/' &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla /etc/sudoers lub /etc/sudoers.d nie są odpowiednio skonfigurowane w załadowanej konfiguracji."
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name; - Zmiany w zakresie administracji systemem (sudoers) są poprawnie zbierane."
else
    exit $exit_status
fi
