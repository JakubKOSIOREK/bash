#!/bin/bash

# Ustawienie ścieżek do katalogów
dir_path=$(dirname "$0")

tests_dir="$dir_path/tests"
reports_dir="$dir_path/reports"
report_name="raport"
report_ext="csv"

# Kolory ANSI (tylko do wydruku na konsolę)
green="\033[0;32m"
red="\033[0;31m"
reset_color="\033[0m"

# Opcje skryptu
show_fail_only=false
silent_mode=false
verbose_mode=false
output_file_name=""
test_identifiers=() # Nowa zmienna dla identyfikatorów testów

# Liczniki
total_tests=0
passed_tests=0
failed_tests=0

# Funkcja pomocnicza
show_help() {
    echo "Użycie: $0 [opcje]"
    echo "Uruchamia skrypty testowe."
    echo ""
    echo "Dostępne opcje:"
    echo "  -f, --fail-only        Wyświetla tylko wyniki nieudanych testów"
    echo "  -r, --report           Zapisuje wyniki testów do pliku z automatycznie generowaną nazwą zawierającą datę"
    echo "  -s, --silent           Nie wyświetla wyników na konsoli"
    echo "  -t, --test <id_testu>  Wykonuje tylko testy o podanych identyfikatorach (oddzielone przecinkami)"
    echo "  -v, --verbose          Wyświetla więcej informacji o testach"
    echo "  -h, --help             Wyświetla ten komunikat"
    echo ""
    exit 0
}

# Przetwarzanie opcji linii poleceń
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--fail-only) show_fail_only=true ;;
        -r|--report)
            if [[ "$2" =~ ^- || -z "$2" ]]; then
                current_date=$(date +"%Y%m%d-%H%M")
                output_file_name="${current_date}_${report_name}.${report_ext}"
            else
                output_file_name="$2"
                shift
            fi ;;
        -s|--silent) silent_mode=true ;;
        -v|--verbose) verbose_mode=true ;;
        -t|--test)
            IFS=',' read -ra test_identifiers <<< "$2"
            shift ;;
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
if [ -n "$output_file_name" ]; then
    output_file="$reports_dir/$output_file_name"
    # Tworzenie nagłówków pliku CSV, jeśli plik nie istnieje
    if [ ! -f "$output_file" ]; then
        echo "Status;Test ID;File Name;Test Title;Additional Info" > "$output_file"
    fi
fi

# Wykonanie testów
test_scripts=()
if [ ${#test_identifiers[@]} -eq 0 ]; then
    test_scripts=("$tests_dir"/*.sh)
else
    for id in "${test_identifiers[@]}"; do
        for found in $(find "$tests_dir" -name "*$id*.sh"); do
            test_scripts+=("$found")
        done
    done
fi

for test_script in "${test_scripts[@]}"; do
    ((total_tests++))
    test_output=$("$test_script" 2>&1)
    test_failed=$(echo "$test_output" | grep -q "FAIL;" && echo "yes" || echo "no")

    IFS=';' read -ra ADDR <<< "$test_output"
    status="${ADDR[0]}"
    test_name="${ADDR[2]}"
    
    if [ "$test_failed" = "yes" ]; then
        ((failed_tests++))
        additional_info="${ADDR[4]}" # Pobranie dodatkowej informacji z outputu testu
        console_output="${red}${status}${reset_color} >>> ${test_name}"
        if [ "$verbose_mode" = true ]; then
            console_output+=" >>> $additional_info" # Dodanie informacji jeśli verbose jest aktywne
        fi
    else
        ((passed_tests++))
        console_output="${green}${status}${reset_color} >>> ${test_name}"
    fi

    if [ -n "$output_file" ]; then
        echo "$test_output" >> "$output_file"
    fi

    if [ "$silent_mode" = false ] && ([ "$show_fail_only" = false ] || ([ "$show_fail_only" = true ] && [ "$test_failed" = "yes" ])); then
        echo -e "$console_output"
    fi
done

# Wyświetlenie podsumowania
if [ "$silent_mode" = false ]; then
    echo "---------------------------------------------"
    echo -e "Wykonano testów: $total_tests | ${green}PASS${reset_color}: $passed_tests | ${red}FAIL${reset_color}: $failed_tests |"
    echo "---------------------------------------------"
fi
