#!/bin/bash

# Ustawienie ścieżki do katalogu z plikami zasad audytu
dir_path=.
main_config_files_dir="$dir_path/tzk_szgdk_config_files"
audit_files="$main_config_files_dir/audit"

# Skopiowanie specyficznego pliku zasad audytu do /etc/audit/rules.d/
echo "Kopiowanie pliku 99-finalize.rules do /etc/audit/rules.d/"
sudo cp "$audit_files/99-finalize.rules" /etc/audit/rules.d/

# Wykonanie augenrules po skopiowaniu nowej zasady audytu
echo "Wykonanie augenrules po skopiowaniu nowej zasady audytu."
sudo augenrules

echo "Restartowanie usługi auditd."
sudo systemctl restart auditd

# Sprawdzenie, czy usługa została pomyślnie zrestartowana
if sudo systemctl is-active --quiet auditd; then
  echo "Usługa auditd została pomyślnie zrestartowana."
else
  echo "Nie udało się zrestartować usługi auditd."
fi

# Wypisanie aktualnych zasad audytu
echo "Aktualne zasady audytu:"
sudo auditctl -l
