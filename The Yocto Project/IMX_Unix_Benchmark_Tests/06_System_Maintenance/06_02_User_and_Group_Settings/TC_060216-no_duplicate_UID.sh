#!/bin/bash

TEST_TITLE="Ensure no duplicate UIDs exist"
TEST_ID=060216

# Array to store test results
results=()

# Function to add test result
add_result() {
    uid="$1"
    users="$2"
    results+=("Duplicate UID ($uid): $users")
}

# Find duplicate UIDs
cut -d: -f3 /etc/passwd | sort -n | uniq -c | while read -r count uid; do
    if [ "$count" -gt 1 ]; then
        # Find users with the duplicate UID
        users=$(awk -F: -v uid="$uid" '($3 == uid) { print $1 }' /etc/passwd | xargs)
        add_result "$uid" "$users"
    fi
done

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Duplicate UIDs found"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
