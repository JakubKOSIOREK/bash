#!/bin/bash

# Wykonanie polecenia w celu znalezienia plików i katalogów nieprzypisanych do żadnej grupy
ungrouped_items=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup)

# Wykonanie polecenia w celu znalezienia symlinków nieprzypisanych do żadnej grupy
ungrouped_links=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type l -nogroup)

# Zmiana grupy dla plików i katalogów
if [ -n "$ungrouped_items" ]; then
    # Przetwarzanie każdego znalezionego elementu
    while IFS= read -r item; do
        # Nadanie grupy root dla znalezionego elementu
        chgrp root "$item" && echo "Zmieniono grupę dla: $item"
    done <<< "$ungrouped_items"
fi

# Zmiana grupy dla symlinków
if [ -n "$ungrouped_links" ]; then
    # Przetwarzanie każdego znalezionego symlinku
    while IFS= read -r link; do
        # Nadanie grupy root dla znalezionego symlinku bez zmiany grupy pliku docelowego
        chgrp -h root "$link" && echo "Zmieniono grupę dla symlinku: $link"
    done <<< "$ungrouped_links"
fi

if [ -n "$ungrouped_items" ] || [ -n "$ungrouped_links" ]; then
    echo "Zmiana grupy wykonana."
else
    echo "Nie znaleziono elementów bez grupy."
fi
