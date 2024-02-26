#!/bin/bash
TEST_TITLE="Ensure all users' last password change date is in the past"
TEST_ID=05040105

# Check each user's last password change date
for user in $(cut -d: -f1 /etc/shadow); do
    last_pw_change=$(chage --list "$user" | grep '^Last password change' | cut -d: -f2)
    if [[ -n "$last_pw_change" ]]; then
        last_pw_change_date=$(date -d "$last_pw_change" +%s)
        current_date=$(date +%s)

        if [[ $last_pw_change_date -gt $current_date ]]; then
            echo "$TEST_ID:$TEST_TITLE:1:User $user has last password change date in the future $last_pw_change"
            exit 1
        fi
    fi
done

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
