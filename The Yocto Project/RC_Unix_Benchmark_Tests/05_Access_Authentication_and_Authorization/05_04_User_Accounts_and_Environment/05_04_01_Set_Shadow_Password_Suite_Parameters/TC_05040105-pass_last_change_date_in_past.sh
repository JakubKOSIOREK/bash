#!/bin/bash
TEST_TITLE="Ensure all users' last password change date is in the past"
TEST_ID=05040105


current_date=$(date +%Y-%m-%d)
current_date_days=$(($(date +%s) /86400))

while IFS=':' read -r user enc_passwd last_change rest; do
    if [[ -n "$last_change" && "$last_change" != "0" ]]; then

        last_change_secs=$((last_change * 86400))

        last_change_date=$(date -d "@$last_change_secs" +%Y-%m-%d)

        if [[ "$last_change" -gt "$current_date_days" ]]; then

            echo "$TEST_ID:$TEST_TITLE:1:User $user has last password change date in the future $last_change_date >> Current system date is $current_date"
            exit 1
        fi
    fi
done </etc/shadow

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
