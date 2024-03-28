#!/bin/bash

test_id="SEC-IPV6-STATUS-DISABLED-001"
test_name="Ensure IPv6 is disabled"
test_fail_messages=() # Tablica na komunikaty o błędach

exit_status=0

# Sprawdzenie czy IPv6 jest wyłączone na poziomie grub
grub_check=$(grep -P '^\s*GRUB_CMDLINE_LINUX' /etc/default/grub | grep 'ipv6.disable=1')

if [[ -z "$grub_check" ]]; then
    test_fail_messages+=(" - IPv6 może być włączone na poziomie GRUB.")
    exit_status=1
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo -e "FAIL;$test_id;$test_name;$test_fail_message"
fi

exit $exit_status
