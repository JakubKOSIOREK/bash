#!/bin/bash
TEST_TITLE="Ensure password expiration warning days is 7 or more"
TEST_ID=05040103

# Check PASS_WARN_AGE in /etc/login.defs
warn_age=$(grep "^PASS_WARN_AGE" /etc/login.defs | awk '{ print $2 }')

# Check if PASS_WARN_AGE is set correctly
if [ -z "$warn_age" ] || [ "$warn_age" -lt 7 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:PASS_WARN_AGE is less than 7 or not set. Current value $warn_age"
    exit 1
fi

# Check each user's password warning age
while IFS=':' read -r user pass warn_age_rest; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ "$warn_age_rest" -lt 7 ]; then
            echo "$TEST_ID:$TEST_TITLE:1:User $user has PASS_WARN_AGE less than 7. Current value $warn_age_rest"
            exit 1
        fi
    fi
done < <(cut -d: -f1,2,6 /etc/shadow)

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
