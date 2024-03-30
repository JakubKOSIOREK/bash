#!/bin/bash

# Określenie katalogu ze skryptami do zmiany nazwy
directory="./testy_do_poprawy"

# Iteracja przez wszystkie pliki .sh zaczynające się od "test"
for file in "$directory"/test*.sh; do
  # Pobranie nazwy pliku bez ścieżki
  filename=$(basename "$file")
  
  # Tworzenie nowej nazwy pliku poprzez zamianę "test" na "TC"
  new_filename="${filename/test/TC}"
  
  # Tworzenie nowej ścieżki pliku
  new_file_path="$directory/$new_filename"
  
  # Zmiana nazwy pliku
  mv "$file" "$new_file_path"
  
  echo "Zmieniono nazwę: $file -> $new_file_path"
done
