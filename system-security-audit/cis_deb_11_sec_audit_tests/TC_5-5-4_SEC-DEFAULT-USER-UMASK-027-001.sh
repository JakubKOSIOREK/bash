#!/usr/bin/env bash

test_id="SEC-DEFAULT-USER-UMASK-027-001"
test_name="Ensure default user umask is 027 or more restrictive"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

expected_umask="027"

# Funkcja do sprawdzenia ustawienia umask w pliku
check_umask_setting() {
    local file=$1
    local umask_setting=$(grep -E "^umask" "$file")

    if [[ -z "$umask_setting" ]]; then
        test_fail_messages+=("$file does not contain umask setting.")
        return 1 # Brak ustawienia umask
    elif [[ ! "$umask_setting" =~ umask\ 0(2[7-9]|3[0-7]) ]]; then
        test_fail_messages+=("umask setting in $file is not restrictive enough: $umask_setting.")
        return 1 # Nieodpowiednie ustawienie umask
    fi
    return 0 # umask jest poprawnie ustawiony
}

# Sprawdzenie ustawienia umask w /etc/bash.bashrc
if ! check_umask_setting "/etc/bash.bashrc"; then
    exit_status=1
fi

# Sprawdzenie ustawienia umask w plikach /etc/profile.d/*.sh
profile_d_files=$(grep -l "umask" /etc/profile.d/*.sh || true)
if [[ -n "$profile_d_files" ]]; then
    for file in $profile_d_files; do
        if ! check_umask_setting "$file"; then
            exit_status=1
            break # Przerwij pętlę po pierwszym napotkanym błędzie
        fi
    done
else
    # Sprawdzenie ustawienia umask w /etc/profile, jeśli nie znaleziono w /etc/profile.d/*.sh
    if ! check_umask_setting "/etc/profile"; then
        exit_status=1
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
