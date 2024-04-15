#!/bin/bash

# Zmienna przechowująca żądane uprawnienia
permissions=750

# Definicja maski uprawnień i maksymalnych uprawnień
perm_mask='0027'
maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
valid_shells="^($(awk 'BEGIN{ORS="|"} /^\//{print $0}' /etc/shells | sed 's/|$//'))$"

# Sprawdzanie i aktualizacja uprawnień katalogów domowych
while IFS=: read -r user _ uid gid _ home shell; do
    if [[ $shell =~ $valid_shells ]] && [ -d "$home" ]; then
        mode=$(stat -L -c '%a' "$home")
        if [ "$(( 0$mode & 0$perm_mask ))" -gt 0 ]; then
            echo "Zmiana uprawnień dla: $home z $mode na $permissions"
            chmod $permissions -R "$home"
        else
            echo "Uprawnienia dla: $home są wystarczająco restrykcyjne: $mode"
        fi
    fi
done < /etc/passwd
