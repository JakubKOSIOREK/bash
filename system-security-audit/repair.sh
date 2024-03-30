#!/bin/bash

# Ustawienie ścieżki do katalogu ze skryptami
dir_path=$(dirname "$0")
scripts_dir="$dir_path/cis_deb_11_sec_repair_tools"

# Kolory ANSI
green="\033[0;32m"
red="\033[0;31m"
l_gray="\033[90m"
reset_color="\033[0m"

# Inicjalizacja liczników
exit_code_0=0
exit_code_1=0
exit_code_2=0
exit_code_other=0
executed_scripts=0  # Licznik wykonanych skryptów

# Sprawdzenie, czy podano argumenty do skryptu
if [ $# -eq 0 ]; then
    echo "Użycie: sudo $0 numer_testu_1 [numer_testu_2 ...]"
    exit 1
fi

#echo "Szukam i wykonuję skrypty zawierające frazy: $@"
#echo "------------------------------------------------"
echo ""

# Przeszukiwanie katalogu ze skryptami
for phrase in "$@"; do
    # Znajdowanie skryptów pasujących do wzorca i ich wykonanie
    for script_path in $(find "$scripts_dir" -type f -name "*$phrase*.sh"); do
        # Sprawdzenie, czy plik jest wykonywalny
        if [ ! -x "$script_path" ]; then
            echo "Skrypt nie jest wykonywalny, ustawiam prawa wykonywalne: $(basename "$script_path")"
            chmod +x "$script_path"
        fi

        # Wyświetlenie informacji o wykonywaniu skryptu
        echo -n "Wykonywanie: $(basename "$script_path") >>> "

        # Wykonanie skryptu i przechwycenie jego wyjścia
        script_output=$("$script_path" 2>/dev/null)

        # Pobranie kodu wyjścia skryptu
        exit_code=$?

        # Zwiększenie odpowiedniego licznika w zależności od kodu wyjścia
        case $exit_code in
            0)
                ((exit_code_0++))
                echo -e "${green}DONE${reset_color}"
                ;;
            1)
                ((exit_code_1++))
                echo -e "${red}ERROR${reset_color}"
                ;;
            2)
                ((exit_code_2++))
                echo -e "${l_gray}N/A${reset_color}"
                ;;
            *)
                ((exit_code_other++))
                echo -e "Sprawdź skrypt"
                ;;
        esac

        # Wyświetlenie wyniku skryptu (output z pliku)
        [ $exit_code -ne 0 ] && [ $exit_code -ne 1 ] && [ $exit_code -ne 2 ] && echo "$script_output"
        #echo "------------------------------------------------"

        # Zwiększenie licznika wykonanych skryptów
        ((executed_scripts++))

    done
done

# Wyświetlenie ilości wystąpień kodów wyjścia i ich opisów
echo "--------------------------------------------------------------"
echo -e "Wykonano napraw: $executed_scripts | ${green}DONE${reset_color}: $exit_code_0 | ${l_gray}N/A${reset_color}: $exit_code_2 | ${red}ERROR${reset_color}: $exit_code_1 |"
echo "--------------------------------------------------------------"
