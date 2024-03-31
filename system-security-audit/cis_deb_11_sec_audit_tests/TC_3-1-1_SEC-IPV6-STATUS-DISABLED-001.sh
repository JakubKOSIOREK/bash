#!/bin/bash

test_id="SEC-IPV6-STATUS-DISABLED-001"
test_name="Ensure IPv6 is disabled"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Array for error messages
exit_status=0

# Check if IPv6 is disabled at the GRUB level
grub_check=$(grep -P '^\s*GRUB_CMDLINE_LINUX' /etc/default/grub | grep 'ipv6.disable=1')

if [[ -z "$grub_check" ]]; then
    test_fail_messages+=("IPv6 może być włączone na poziomie GRUB-a.")
    exit_status=1
fi

# Reporting the result
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
