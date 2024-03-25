#!/bin/bash

dir_path=$(dirname "$0")
tests_dir="$dir_path/tests" # katalog roboczy 
#tests_dir="$dir_path/cis_deb_11_sec_audit_tests" # katalog docelowy
reports_dir="$dir_path/reports"

show_fail_only=false
silent_mode=false
output_file_name=""

# Inicjalizacja liczników
total_tests=0
passed_tests=0
failed_tests=0

#Inicjalizacja kolorów ANSI
green="\033[0;32m"
red="\033[0;31m"
reset="\033[0m"

show_help() {
    echo "Użycie: $0 [opcje]"
    echo "Uruchamia skrypty testowe."
    echo ""
    echo "Dostępne opcje:"
    echo "  -f, --fail-only    Wyświetla tylko wyniki nieudanych testów"
    echo "  -o, --output FILE  Zapisuje wyniki testów do pliku FILE w formacie CSV w katalogu 'reports'"
    echo "  -s, --silent       Nie wyświetla żadnych wyników na konsoli"
    echo "  -h, --help         Wyświetla ten komunikat z pomocą"
    echo ""
    exit 0
}

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

if [ ! -d "$reports_dir" ]; then
    mkdir -p "$reports_dir"
fi

output_file=""
current_date=$(date +"%Y-%m-%d-%H%M")
if [ -n "$output_file_name" ]; then
    output_file="$reports_dir/${current_date}_$output_file_name"
    #echo "test_status;test_id;test_name;test_fail_message;" > "$output_file"
fi

for test_script in "$tests_dir"/*.sh; do
    ((total_tests++)) # Inkrementacja licznika wszystkich testów
    test_output=$("$test_script" 2>&1)
    test_failed=$(echo "$test_output" | grep -q "FAIL;" && echo "yes" || echo "no")
    
    if [ "$test_failed" = "yes" ]; then
        ((failed_tests++)) # Inkrementacja licznika nieudanych testów
    else
        ((passed_tests++)) # Inkrementacja licznika udanych testów
    fi
    
    # Zapisz wynik do pliku, jeśli określono plik wyjściowy
    if [ ! -z "$output_file" ]; then
        echo "$test_output" >> "$output_file"
    fi
    
    # Decyduj o wyświetlaniu wyników na podstawie trybu cichego i opcji --fail-only
    if [ "$silent_mode" = false ]; then
        if [ "$show_fail_only" = true ] && [ "$test_failed" = "yes" ]; then
            echo "$test_output"
            echo "---------------------------------------------"
        elif [ "$show_fail_only" = false ]; then
            echo "$test_output"
            echo "---------------------------------------------"
        fi
    fi
done

# Wyświetl podsumowanie, jeśli nie jesteśmy w trybie cichym
if [ "$silent_mode" = false ]; then
    echo -e "Wykonano testów: $total_tests" "|" "${green}PASS${reset}: $passed_tests" "|" "${red}FAIL${reset}: $failed_tests" "|"
    echo "---------------------------------------------" 
fi
