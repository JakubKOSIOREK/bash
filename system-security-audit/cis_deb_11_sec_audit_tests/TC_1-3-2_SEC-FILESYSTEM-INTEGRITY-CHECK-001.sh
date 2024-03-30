#!/bin/bash

test_id="SEC-FILESYSTEM-INTEGRITY-CHECK-001"
test_name="Ensure filesystem integrity is regularly checked"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie zaplanowanych zadań cron dla AIDE
cron_result=$(grep -Prs '^([^#\n\r]+\h+)?(\/usr\/s?bin\/|^\h*)aide(\.wrapper)?\h+(--check|([^#\n\r]+\h+)?\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/)

# Sprawdzenie, czy usługi systemd aidecheck są włączone i czy timer działa
systemctl_enabled=$(systemctl is-enabled aidecheck.service 2>/dev/null && systemctl is-enabled aidecheck.timer 2>/dev/null)
systemctl_status=$(systemctl status aidecheck.timer 2>/dev/null | grep -qw "active" && echo "active")

if [[ -z "$cron_result" && ("$systemctl_enabled" != "enabled" || "$systemctl_status" != "active") ]]; then
    test_fail_messages+=("Regularna kontrola integralności systemu plików nie jest zaplanowana lub aktywna.")
    exit_status=1
else
    echo "PASS;${test_id};${test_file};${test_name};"
    exit 0
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 1 ]; then
    echo "FAIL;${test_id};${test_file};${test_name};${test_fail_message}"
fi

exit $exit_status
