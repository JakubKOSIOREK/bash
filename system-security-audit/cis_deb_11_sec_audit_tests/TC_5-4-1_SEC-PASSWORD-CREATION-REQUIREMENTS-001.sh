#!/usr/bin/env bash

test_id="SEC-PASSWORD-CREATION-REQUIREMENTS-001"
test_name="Ensure password creation requirements are configured"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

libpam_module="libpwquality-common"

# Sprawdzenie, czy moduł pam_pwquality jest zainstalowany
if ! dpkg -s $libpam_module &> /dev/null; then
    test_fail_messages+=("$libpam_module module is not installed.")
    exit_status=1
fi

# Sprawdzenie minimalnej długości hasła
minlen=$(grep '^\s*minlen\s*=' /etc/security/pwquality.conf  2>/dev/null | awk '{print $3}')
if [[ "$minlen" -lt 14 ]]; then
    test_fail_messages+=("Password minlen is less than 14.")
    exit_status=1
fi

# Sprawdzenie złożoności hasła
minclass=$(grep '^\s*minclass\s*=' /etc/security/pwquality.conf  2>/dev/null | awk '{print $3}')
dcredit=$(grep '^\s*dcredit\s*=' /etc/security/pwquality.conf  2>/dev/null | awk '{print $3}')
ucredit=$(grep '^\s*ucredit\s*=' /etc/security/pwquality.conf  2>/dev/null | awk '{print $3}')
ocredit=$(grep '^\s*ocredit\s*=' /etc/security/pwquality.conf  2>/dev/null | awk '{print $3}')
lcredit=$(grep '^\s*lcredit\s*=' /etc/security/pwquality.conf  2>/dev/null | awk '{print $3}')

if [[ "$minclass" != "4" ]] && { [[ "$dcredit" != "-1" ]] || [[ "$ucredit" != "-1" ]] || [[ "$ocredit" != "-1" ]] || [[ "$lcredit" != "-1" ]]; }; then
    test_fail_messages+=("Password complexity not correctly configured.")
    exit_status=1
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
