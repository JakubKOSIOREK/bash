#!/usr/bin/env bash

test_id="SEC-DATE-TIME-MODIFICATION-COLLECTED-001"
test_name="Ensure events that modify date and time information are collected"
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest zainstalowane."
    exit 1
fi

# Funkcja do sprawdzania reguł na dysku i w konfiguracji załadowanej
check_audit_rules() {
    local type="$1"
    local arch_rules="$2"
    local localtime_rule="$3"
    
    if [ "${type}" == "disk" ]; then
        audit_rules=$(awk "${arch_rules}" /etc/audit/rules.d/*.rules && awk "${localtime_rule}" /etc/audit/rules.d/*.rules)
    elif [ "${type}" == "loaded" ]; then
        audit_rules=$(auditctl -l | awk "${arch_rules}" && auditctl -l | awk "${localtime_rule}")
    fi

    if ! echo "${audit_rules}" | grep -q -P "^-a always,exit -F arch=b[2364]{2} -S adjtimex,settimeofday,clock_settime -k time-change$" || ! echo "${audit_rules}" | grep -q -P "^-w /etc/localtime -p wa -k time-change$"; then
        echo "FAIL;$test_id;$test_name; - Reguły audytu dla modyfikacji daty i czasu nie są odpowiednio skonfigurowane (${type})."
        exit_status=1
    fi
}

# Architektura 64-bitowa i 32-bitowa
arch_rules="/^\s*-a\s+always,exit\s+/ && /-F\s+arch=b[2364]{2}\s+/ && /-S\s+/ && ( /adjtimex/ || /settimeofday/ || /clock_settime/ ) && ( /key=\s*\S+\s*$/ || /-k\s+\S+\s*$/ )"
# Reguła dla /etc/localtime
localtime_rule="/^\s*-w\s+/ && /\/etc\/localtime/ && /-p\s+wa/ && ( /key=\s*\S+\s*$/ || /-k\s+\S+\s*$/ )"

# Sprawdzanie konfiguracji na dysku
check_audit_rules "disk" "${arch_rules}" "${localtime_rule}"

# Sprawdzanie załadowanej konfiguracji
check_audit_rules "loaded" "${arch_rules}" "${localtime_rule}"

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
