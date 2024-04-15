#!/bin/bash

# Usunięcie wszystkich załadowanych reguł audytu
sudo auditctl -D

# Usunięcie wszystkich plików reguł z /etc/audit/rules.d/
sudo rm -f /etc/audit/rules.d/*

# Sprawdzenie, czy reguły zostały usunięte
if sudo auditctl -l | grep -q "No rules"; then
    echo "Wszystkie reguły audytu zostały usunięte."
else
    echo "Nie udało się usunąć wszystkich reguł."
    exit 1
fi

# Kopiowanie nowego pliku reguł audytu
sudo cp ./tzk_szgdk_config_files/audit/00-TZK-audit.rules /etc/audit/rules.d/

# Restart usługi auditd, aby załadować nowe reguły
sudo systemctl restart auditd

# Sprawdzenie, czy nowe reguły zostały załadowane
if sudo auditctl -l | grep -v "No rules"; then
    echo "Nowe reguły audytu zostały załadowane."
else
    echo "Nie udało się załadować nowych reguł."
    exit 1
fi

echo "Operacja zakończona sukcesem."
