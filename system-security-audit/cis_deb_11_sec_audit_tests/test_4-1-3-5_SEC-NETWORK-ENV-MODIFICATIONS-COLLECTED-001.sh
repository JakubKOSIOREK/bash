#!/usr/bin/env bash

test_id="SEC-NETWORK-ENV-MODIFICATIONS-COLLECTED-001"
test_name="Ensure events that modify the system's network environment are collected"
exit_status=0

# Sprawdzenie, czy auditd jest zainstalowany
if ! command -v auditctl &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie auditctl nie jest zainstalowane."
    exit 1
fi

# Definicja reguł do sprawdzenia
syscall_rules="/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -S/ && ( /sethostname/ || /setdomainname/ ) && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )"
file_rules="/^ *-w/ && ( /\/etc\/issue/ || /\/etc\/issue.net/ || /\/etc\/hosts/ || /\/etc\/networks/ || /\/etc\/network\// ) && / +-p *wa/ && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )"

# Sprawdzanie reguł na dysku
if ! awk "${syscall_rules}" /etc/audit/rules.d/*.rules &> /dev/null || ! awk "${file_rules}" /etc/audit/rules.d/*.rules &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla modyfikacji środowiska sieciowego nie są odpowiednio skonfigurowane na dysku."
    exit_status=1
fi

# Sprawdzanie załadowanych reguł
if ! auditctl -l | awk "${syscall_rules}" &> /dev/null || ! auditctl -l | awk "${file_rules}" &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Reguły audytu dla modyfikacji środowiska sieciowego nie są odpowiednio skonfigurowane w załadowanej konfiguracji."
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    exit $exit_status
fi
