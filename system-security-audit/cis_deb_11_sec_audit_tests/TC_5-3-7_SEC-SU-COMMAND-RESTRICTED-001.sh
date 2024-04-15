#!/usr/bin/env bash

test_id="SEC-SU-COMMAND-RESTRICTED-001"
test_name="Ensure access to the su command is restricted"

# Pobranie nazwy pliku skryptu
script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Wyszukiwanie konfiguracji pam_wheel.so w pliku /etc/pam.d/su
if ! grep -Pi '^\s*auth\s+(?:required|requisite)\s+pam_wheel\.so\s+(?:[^#\n\r]+\s+)?((?!\2)use_uid\b|group=\H+\b)\s+((?:[^#\n\r]+\s+)?((?!\1)(use_uid\b|group=\H+\b))(\s+.*)?)?$' /etc/pam.d/su &>/dev/null; then
    test_fail_messages+=("Konfiguracja pam_wheel.so nie wymaga członkostwa w grupie lub nie jest ustawiona na używanie use_uid.")
    exit_status=1
else
    # Jeśli znaleziono konfigurację, sprawdź, czy grupa jest pusta lub zawiera tylko "administrator"
    group_name=$(grep -Po '^\s*auth\s+required\s+pam_wheel\.so\s+use_uid\s+group=\K[^ ]+' /etc/pam.d/su)
    if [ -z "$group_name" ]; then
        test_fail_messages+=("Nie określono grupy w konfiguracji pam_wheel.so.")
        exit_status=1
    else
        # Pobranie listy użytkowników w grupie
        group_members=$(getent group "$group_name" | cut -d: -f4)
        
        # Sprawdzenie, czy w grupie są inni użytkownicy oprócz "administrator"
        if [[ -z "$group_members" ]] || [[ "$group_members" == "administrator" ]]; then
            # Grupa jest uznawana za pustą, jeśli nie ma użytkowników lub jest tylko "administrator"
            test_fail_messages+=("Grupa $group_name jest pusta lub zawiera tylko 'administrator'.")
            # Tutaj zakładamy, że taki stan jest oczekiwany, więc nie ustawiamy exit_status na 1
            # Jeśli jednak stan ten ma być traktowany jako błąd, odkomentuj poniższą linię
            # exit_status=1
        else
            # W grupie są inni użytkownicy, co jest traktowane jako błąd
            test_fail_messages+=("Grupa $group_name zawiera użytkowników oprócz 'administrator'.")
            exit_status=1
        fi
    fi
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status