#!/bin/bash

# Ustawienie ścieżki do katalogu z plikami zasad audytu
#dir_path=$(dirname "$0")
dir_path=.
main_config_files_dir="$dir_path/tzk_szgdk_config_files"
audit_files="$main_config_files_dir/audit"

# Usuwanie wszystkich plików z zasadami audytu z katalogu /etc/audit/rules.d/
echo "Usuwanie istniejących zasad audytu..."
sudo rm -f /etc/audit/rules.d/*.rules

# Czyszczenie wszystkich aktywnych zasad audytu
echo "Czyszczenie aktywnych zasad audytu..."
sudo auditctl -D

# Wykonanie augenrules
echo "Wykonanie augenrules..."
sudo augenrules

# Zawsze kopiowanie zasad z katalogu $audit_files.
echo "Kopiowanie zasad z katalogu $audit_files."
# Liczba plików źródłowych do skopiowania (pomijając 99-finalize.rules)
num_src_files=$(find "$audit_files" -type f ! -name '99-finalize.rules' | wc -l)

# Znajdź i skopiuj wszystkie pliki z $audit_files do /etc/audit/rules.d/, pomijając 99-finalize.rules
find "$audit_files" -type f ! -name '99-finalize.rules' -exec sudo cp {} /etc/audit/rules.d/ \;

# Wykonanie augenrules po skopiowaniu nowych zasad audytu
echo "Wykonanie augenrules po skopiowaniu nowych zasad audytu."
sudo augenrules

echo "Restartowanie usługi auditd."
sudo systemctl restart auditd

# Sprawdzenie, czy usługa została pomyślnie zrestartowana
if sudo systemctl is-active --quiet auditd; then
  echo "Usługa auditd została pomyślnie zrestartowana."
  
  echo "Aktualne zasady audytu:"
  sudo auditctl -l
else
  echo "Nie udało się zrestartować usługi auditd."
fi
