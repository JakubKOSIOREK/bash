#!/bin/bash

test_id="FIREWALL-CHECK-001"
test_name="Ensure a firewall is installed and active"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Lista firewalli do sprawdzenia
firewalls=("iptables" "firewalld" "ufw" "nftables")
found_firewalls=()

# Funkcja do sprawdzania iptables, ponieważ nie jest on zarządzany przez systemctl
check_iptables() {
    if iptables -L > /dev/null 2>&1; then
        found_firewalls+=("iptables")
    fi
}

# Sprawdzanie iptables
check_iptables

# Sprawdzanie pozostałych firewalli
for fw in "${firewalls[@]:1}"; do
    if systemctl is-active --quiet $fw; then
        found_firewalls+=("$fw")
    fi
done

# Logika decyzyjna na podstawie znalezionych firewalli
if [ ${#found_firewalls[@]} -eq 0 ]; then
    test_fail_messages+=(" - Nie znaleziono aktywnego firewalla. Zalecane jest zainstalowanie i aktywacja jednego z nich: ${firewalls[*]}.")
    exit_status=1
elif [ ${#found_firewalls[@]} -gt 1 ]; then
    test_fail_messages+=(" - Znaleziono więcej niż jeden aktywny firewall: ${found_firewalls[*]}. Konfiguracja wielu firewalli może prowadzić do konfliktów.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
