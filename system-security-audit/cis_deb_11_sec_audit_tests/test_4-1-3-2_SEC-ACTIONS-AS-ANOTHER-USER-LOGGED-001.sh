#!/usr/bin/env bash

test_id="SEC-ACTIONS-AS-ANOTHER-USER-LOGGED-001"
test_name="Ensure actions as another user are always logged"
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest zainstalowane."
    exit 1
fi

# Sprawdzanie konfiguracji na dysku
disk_config=$(awk '/^\s*-a\s+always,exit/ && /-F\s+arch=b[2346]{2}/ && (/-F\s+auid!=unset/||/-F\s+auid!=-1/||/-F\s+auid!=4294967295/) && (/-C\s+euid!=uid/||/-C\s+uid!=euid/) && /-S\s+execve/ && (/\s+key=\s*\S+$/||/\s+-k\s+\S+$/)' /etc/audit/rules.d/*.rules)

# Sprawdzanie załadowanej konfiguracji
loaded_config=$(auditctl -l | awk '/^\s*-a\s+always,exit/ && /-F\s+arch=b[2346]{2}/ && (/-F\s+auid!=unset/||/-F\s+auid!=-1/||/-F\s+auid!=4294967295/) && (/-C\s+euid!=uid/||/-C\s+uid!=euid/) && /-S\s+execve/ && (/\s+key=\s*\S+$/||/\s+-k\s+\S+$/)')

# Weryfikacja konfiguracji na dysku
if [[ -z "$disk_config" ]]; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla działania jako inny użytkownik nie są odpowiednio skonfigurowane na dysku."
    exit_status=1
fi

# Weryfikacja załadowanej konfiguracji
if [[ -z "$loaded_config" ]]; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla działania jako inny użytkownik nie są odpowiednio skonfigurowane w załadowanej konfiguracji."
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name; - Działania jako inny użytkownik są poprawnie rejestrowane."
else
    exit $exit_status
fi
