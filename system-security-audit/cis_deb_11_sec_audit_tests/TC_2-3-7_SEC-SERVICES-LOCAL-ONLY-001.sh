#!/bin/bash

test_id="SEC-SERVICES-LOCAL-ONLY-001"
test_name="Ensure non-essential services are removed or masked"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Array for error messages
exit_status=0

# Whitelist of allowed services
white_list="" # Add services from the security policy here

# Execute the ss command to check for listening services
listening_services=$(ss -plntu | grep -E -v '127.0.0.1|::1' | grep -v 'State')

# Filter out services that are not on the whitelist
for service in $white_list; do
    listening_services=$(echo "$listening_services" | grep -v "$service")
done

if [ ! -z "$listening_services" ]; then
    # Adding services as a single line separated by ';'
    listening_services_formatted=$(echo "$listening_services" | tr '\n' ';' | sed 's/;$//')
    test_fail_messages+=("$listening_services_formatted")
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
