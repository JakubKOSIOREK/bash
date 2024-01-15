#!/bin/bash
TEST_TITLE="Ensure inactive password lock is 30 days or less"
TEST_ID=05040104

# Check the system default for INACTIVE
inactive_default=$(useradd -D | grep INACTIVE | cut -d= -f2)

# Check if system default INACTIVE is 30 days or less
if [ -z "$inactive_default" ] || [ "$inactive_default" -gt 30 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:System default INACTIVE is more than 30 days or not set. Current value $inactive_default"
    exit 1
fi

# Check each user's INACTIVE setting
while IFS=':' read -r user pass inactive_days; do
    if [ "$pass" != '*' ] && [ "$pass" != '!' ]; then
        if [ -z "$inactive_days" ] || [ "$inactive_days" -gt 30 ]; then
            echo "$TEST_ID:$TEST_TITLE:1:User $user has INACTIVE setting more than 30 days or not set. Current value $inactive_days"
            exit 1
        fi
    fi
done < <(cut -d: -f1,2,7 /etc/shadow)

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
