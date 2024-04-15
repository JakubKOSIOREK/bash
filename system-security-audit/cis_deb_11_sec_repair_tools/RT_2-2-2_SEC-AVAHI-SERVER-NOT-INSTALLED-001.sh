#!/bin/bash

# Sprawdzenie, czy avahi-daemon jest zainstalowany
INSTALLED=$(dpkg-query -W -f='${Status}\n' avahi-daemon 2>/dev/null | grep "install ok installed")

if [ -z "$INSTALLED" ]; then
  echo "avahi-daemon nie jest zainstalowany. Brak działań."
else
  echo "avahi-daemon jest zainstalowany. Rozpoczęcie procesu usuwania..."

  # Zatrzymywanie usług
  systemctl stop avahi-daemon.service
  systemctl stop avahi-daemon.socket

  # Usuwanie pakietu
  apt purge -y avahi-daemon

  echo "avahi-daemon został odinstalowany."

  # Definicja ścieżki katalogu
  directory_path="/run/avahi-daemon"

  # Sprawdzenie, czy katalog istnieje
  if [ -d "$directory_path" ]; then
      echo "Katalog $directory_path istnieje. Usuwam..."
      # Usunięcie katalogu wraz z zawartością
      sudo rm -rf "$directory_path"
    
      # Sprawdzenie, czy usunięcie się powiodło
      if [ ! -d "$directory_path" ]; then
          echo "Katalog $directory_path został pomyślnie usunięty."
      else
          echo "Nie udało się usunąć katalogu $directory_path."
      fi
  else
      echo "Katalog $directory_path nie istnieje."
  fi
fi
