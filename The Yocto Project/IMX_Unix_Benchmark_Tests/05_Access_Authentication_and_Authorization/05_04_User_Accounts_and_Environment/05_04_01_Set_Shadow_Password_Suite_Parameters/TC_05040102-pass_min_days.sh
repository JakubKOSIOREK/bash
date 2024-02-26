#!/bin/bash
TEST_TITLE="Ensure minimum days between password changes is configured"
TEST_ID=05040102
PASS_MIN_DAYS=1

# Check PASS_MIN_DAYS in /etc/login.defs
min_days=$(grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{ print $2 }')

# Check if PASS_MIN_DAYS is set correctly
if [ -z "$min_days" ] || [ "$min_days" -lt "$PASS_MIN_DAYS" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:PASS_MIN_DAYS is less than $PASS_MIN_DAYS or not set. Current value $min_days"
    exit 1
fi

# Check each user's minimum password age
while IFS=':' read -r user pass min_days_rest; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ "$min_days_rest" -lt "$PASS_MIN_DAYS" ]; then
            echo "$TEST_ID:$TEST_TITLE:1:User $user has PASS_MIN_DAYS less than $PASS_MIN_DAYS. Current value $min_days_rest"
            exit 1
        fi
    fi
done < <(cut -d: -f1,2,4 /etc/shadow)

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
