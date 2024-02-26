#!/bin/bash
TEST_TITLE="Ensure system accounts are secured"
TEST_ID=050402
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Define excluded accounts
EXCLUDED_ACCOUNTS="root sync shutdown halt"

# Convert EXCLUDED_ACCOUNTS string into an array
read -ra EXCLUDED_ARRAY <<< "$EXCLUDED_ACCOUNTS"

# Check for system accounts not set to nologin or /bin/false
FAIL=0

while IFS=: read -r username _ _ userid _ _ shell; do
    # Skip if user ID is above UID_MIN or in excluded list
    if (( userid >= UID_MIN )) || [[ " ${EXCLUDED_ARRAY[*]} " =~ " ${username} " ]]; then
        continue
    fi

    # Check if the shell is not nologin or /bin/false
    if [[ "$shell" != "$(which nologin)" && "$shell" != "/bin/false" ]]; then
        echo "$TEST_ID:$TEST_TITLE:1: Account $username is not set to nologin or /bin/false"
        FAIL=1
    fi
done < /etc/passwd

if [ $FAIL -eq 1 ]; then
    echo "$TEST_ID:$TEST_TITLE:1: At least one account is not properly configured"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
