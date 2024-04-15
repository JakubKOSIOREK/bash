#!/bin/bash

# Ścieżka do pliku konfiguracyjnego
config_file="/etc/audit/auditd.conf"

# Sprawdzenie, czy plik istnieje
if [ ! -f "$config_file" ]; then
    echo "Plik konfiguracyjny $config_file nie istnieje."
    exit 1
fi

# Zmiana wartości 'space_left_action'
sudo sed -i 's/^space_left_action.*/space_left_action = email/' "$config_file"

# Zmiana wartości 'action_mail_acct'
sudo sed -i 's/^action_mail_acct.*/action_mail_acct = root/' "$config_file"

# Zmiana wartości 'admin_space_left_action'
sudo sed -i 's/^admin_space_left_action.*/admin_space_left_action = halt/' "$config_file"

# Sprawdzenie, czy polecenia się powiodły
if grep -q "^space_left_action = email" "$config_file" &&
   grep -q "^action_mail_acct = root" "$config_file" &&
   grep -q "^admin_space_left_action = halt" "$config_file"; then
    echo "Pomyślnie zmieniono wartości w $config_file."
else
    echo "Nie udało się zmienić wszystkich wartości w $config_file."
fi

# Przeładowanie usługi auditd, aby zmiany weszły w życie
sudo systemctl restart auditd
echo "Usługa auditd została przeładowana."
