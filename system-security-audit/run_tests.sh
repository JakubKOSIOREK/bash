#!/bin/bash

# Ustawienie ścieżek do katalogów
dir_path=$(dirname "$0")
tests_dir="$dir_path/tests" # Ścieżka do katalogu z testami
#tests_dir="$dir_path/cis_deb_11_sec_audit_tests" # katalog docelowy
reports_dir="$dir_path/reports" # Ścieżka do katalogu z raportami

# Opcje skryptu
show_fail_only=false
silent_mode=false
output_file_name=""

# Liczniki
total_tests=0
passed_tests=0
failed_tests=0

# Kolory ANSI
green="\033[0;32m"
red="\033[0;31m"
reset="\033[0m"

# Funkcja pomocnicza
show_help() {
    echo "Użycie: $0 [opcje]"
    echo "Uruchamia skrypty testowe."
    echo ""
    echo "Dostępne opcje:"
    echo "  -f, --fail-only        Wyświetla tylko wyniki nieudanych testów"
    echo "  -o, --output file.csv  Zapisuje wyniki testów do pliku .csv"
    echo "  -s, --silent           Nie wyświetla wyników na konsoli"
    echo "  -h, --help             Wyświetla ten komunikat"
    echo ""
    exit 0
}

# Przetwarzanie opcji linii poleceń
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--fail-only) show_fail_only=true ;;
        -o|--output) output_file_name="$2"; shift ;;
        -s|--silent) silent_mode=true ;;
        -h|--help) show_help ;;
        *) echo "Nieznana opcja: $1" >&2; exit 1 ;;
    esac
    shift
done

# Tworzenie katalogu raportów, jeśli nie istnieje
if [ ! -d "$reports_dir" ]; then
    mkdir -p "$reports_dir"
fi

output_file=""
current_date=$(date +"%Y-%m-%d-%H%M")
if [ -n "$output_file_name" ]; then
    output_file="$reports_dir/${current_date}_$output_file_name"
fi

separator="---------------------------------------------"

# Wykonanie testów
for test_script in "$tests_dir"/*.sh; do
    ((total_tests++))
    test_script_name=$(basename "$test_script") # Zapisanie nazwy pliku skryptu
    test_output=$("$test_script" 2>&1)
    test_failed=$(echo "$test_output" | grep -q "FAIL;" && echo "yes" || echo "no")
    
    if [ "$test_failed" = "yes" ]; then
        ((failed_tests++))
    else
        ((passed_tests++))
    fi
    
    test_result="Test: $test_script_name\n$test_output" # Dodanie nazwy pliku do wyniku
    
    if [ -n "$output_file" ]; then
        echo -e "$test_result" >> "$output_file"
    fi
    
    if [ "$silent_mode" = false ]; then
        if [ "$show_fail_only" = true ] && [ "$test_failed" = "yes" ]; then
            echo -e "$test_result"
            echo "$separator"
        elif [ "$show_fail_only" = false ]; then
            echo -e "$test_result"
            echo "$separator"
        fi
    fi
done

# Wyświetlenie podsumowania
if [ "$silent_mode" = false ]; then
    echo -e "Wykonano testów: $total_tests | ${green}PASS${reset}: $passed_tests | ${red}FAIL${reset}: $failed_tests |"
    echo "$separator"
fi
