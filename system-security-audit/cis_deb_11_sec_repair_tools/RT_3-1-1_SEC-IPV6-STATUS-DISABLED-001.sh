#!/bin/bash

# Lokalizacja pliku konfiguracyjnego GRUB
GRUB_CONFIG="/etc/default/grub"

# Flagi do dodania
NEEDED_FLAGS=("ipv6.disable=1")

# Sprawdzenie i dodanie brakujących flag
for flag in "${NEEDED_FLAGS[@]}"; do
    if ! grep -q "$flag" "$GRUB_CONFIG"; then
        echo "Dodawanie $flag do $GRUB_CONFIG"
        # Dodanie flagi do GRUB_CMDLINE_LINUX_DEFAULT
        sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=\"/ s/\"$/ $flag\"/" "$GRUB_CONFIG"
    else
        echo "$flag już obecny w $GRUB_CONFIG"
    fi
done

# Aktualizacja konfiguracji GRUB
echo "Aktualizacja konfiguracji GRUB..."
update-grub

echo "Zakończono."
