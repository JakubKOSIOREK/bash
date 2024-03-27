#!/usr/bin/env bash

test_id="SEC-SU-COMMAND-RESTRICTED-001"
test_name=" Ensure access to the su command is restricted"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Wyszukiwanie konfiguracji pam_wheel.so w pliku /etc/pam.d/su
if ! grep -Pi '^\s*auth\s+(?:required|requisite)\s+pam_wheel\.so\s+(?:[^#\n\r]+\s+)?((?!\2)use_uid\b|group=\H+\b)\s+(?:[^#\n\r]+\s+)?((?!\1)(use_uid\b|group=\H+\b))(\s+.*)?$' /etc/pam.d/su &>/dev/null; then
    test_fail_messages+=(" - Konfiguracja pam_wheel.so nie wymaga członkostwa w grupie lub nie jest ustawiona na używanie use_uid.")
    exit_status=1
else
    # Jeśli znaleziono konfigurację, sprawdź, czy grupa jest pusta
    group_name=$(grep -Po '^\s*auth\s+required\s+pam_wheel\.so\s+use_uid\s+group=\K\H+' /etc/pam.d/su)
    if [ -z "$group_name" ]; then
        test_fail_messages+=(" - Nie określono grupy w konfiguracji pam_wheel.so.")
        exit_status=1
    else
        if grep "$group_name" /etc/group | cut -d: -f4 | grep -q '[^,]'; then
            test_fail_messages+=(" - Grupa $group_name zawiera użytkowników.")
            exit_status=1
        fi
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
