#!/bin/bash

# Wyszukiwanie dyrektywy Defaults use_pty w plikach sudoers
sudoers_files=$(grep -rPl '^\s*Defaults\s+([^#\n\r]+,)?use_pty(,\s*\S+\s*)*\s*(#.*)?$' /etc/sudoers /etc/sudoers.d)

if [[ -z "$sudoers_files" ]]; then

    # Tworzenie pliku z dyrektywą use_pty
    echo "Dodawanie dyrektywy 'Defaults use_pty' do nowego pliku w /etc/sudoers.d/"
    echo "Defaults use_pty" > /etc/sudoers.d/use_pty
    
    # Ustawienie bezpiecznych uprawnień dla nowego pliku
    chmod 0440 /etc/sudoers.d/use_pty
    
    echo "Dyrektywa 'Defaults use_pty' została dodana."
else
    echo "Dyrektywa 'Defaults use_pty' jest już obecna w plikach sudoers."
fi
