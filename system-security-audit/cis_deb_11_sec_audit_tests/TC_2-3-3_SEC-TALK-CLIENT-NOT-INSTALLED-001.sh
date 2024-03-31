#!/bin/bash

test_id="SEC-TALK-CLIENT-NOT-INSTALLED-001"
test_name="Ensure Talk Client is not installed"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Array for error messages
exit_status=0

# List of packages to check - can be adjusted as needed
packages_to_check="talk"

# Verification if any of the packages are installed
if dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' $packages_to_check 2>/dev/null | grep -Pi '\h+installed\b'; then
    installed_packages=$(dpkg-query -W -f='${binary:Package}\n' $packages_to_check | grep -v 'no packages found matching')
    test_fail_messages+=("Found installed packages: $installed_packages")
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
