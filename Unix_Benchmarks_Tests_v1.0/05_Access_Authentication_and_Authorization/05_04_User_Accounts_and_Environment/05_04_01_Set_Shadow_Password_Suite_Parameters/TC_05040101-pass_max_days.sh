#!/bin/bash
TEST_TITLE="Ensure password expiration is 365 days or less"
TEST_ID=05040101

# Check PASS_MAX_DAYS in /etc/login.defs
max_days=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{ print $2 }')

# Check if PASS_MAX_DAYS is set correctly
if [ -z "$max_days" ] || [ "$max_days" -gt 365 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:PASS_MAX_DAYS is more than 365 or not set. Current value $max_days"
    exit 1
fi

# Check each user's maximum password age
while IFS=':' read -r user pass max_days_rest; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ "$max_days_rest" -gt 365 ] || [ "$max_days_rest" -eq -1 ]; then
            echo "$TEST_ID:$TEST_TITLE:1:User $user has PASS_MAX_DAYS more than 365 or disabled. Current value $max_days_rest"
            exit 1
        fi
    fi
done < <(cut -d: -f1,2,5 /etc/shadow)

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
