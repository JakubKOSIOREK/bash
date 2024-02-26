#!/bin/bash

TEST_TITLE="Ensure no duplicate user names exist"
TEST_ID=060218

# Array to store test results
results=()

# Function to add test result
add_result() {
    username="$1"
    results+=("Duplicate login name ($username)")
}

# Find duplicate login names
cut -d: -f1 /etc/passwd | sort | uniq -d | while read username; do
    if [ -n "$username" ]; then
        add_result "$username"
    fi
done

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Duplicate user names found"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
