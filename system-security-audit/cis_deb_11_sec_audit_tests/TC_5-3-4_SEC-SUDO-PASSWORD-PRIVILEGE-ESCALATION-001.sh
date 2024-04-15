#!/usr/bin/env bash

test_id="SEC-SUDO-PASSWORD-PRIVILEGE-ESCALATION-001"
test_name="Ensure users must provide password for privilege escalation"

# Pobranie nazwy pliku skryptu
script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Lista wykluczeń
exclusions=(
    "/sbin/hwclock"
    "/sbin/hwclock --systohc"
    "/dev/rtc0"
    "/bin/date"
    "/bin/date -s"
    "/usr/bin/timedatectl"
    "/usr/bin/timedatectl set-timezone"
)

# Przekształcanie listy wykluczeń na wzorzec wyrażenia regularnego
exclusions_pattern=$(IFS='|'; echo "${exclusions[*]}")
exclusions_pattern="(${exclusions_pattern//\//\\/})" # Zastąpienie '/' na '\/' dla poprawnej interpretacji ścieżek

# Wyszukiwanie dyrektyw NOPASSWD niezawierających wykluczeń
nopasswd_entries=$(grep -rP "^[^#]*\bNOPASSWD\b" /etc/sudoers /etc/sudoers.d | grep -vP "$exclusions_pattern" | tr '\n' ';')

# Usuwanie ostatniego średnika
nopasswd_entries=${nopasswd_entries%;}

if [[ -n "$nopasswd_entries" ]]; then
    test_fail_messages+=("$nopasswd_entries")
    exit_status=1
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
