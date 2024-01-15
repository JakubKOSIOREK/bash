#!/bin/bash

TEST_TITLE="Ensure all users' home directories exist"
TEST_ID=060203

# Array to store test results
results=()

# Function to add test result
add_result() {
    user="$1"
    dir="$2"
    if [ ! -d "$dir" ]; then
        results+=("FAIL: The home directory ($dir) of user ${user} does not exist.")
    fi
}

# Execute the command to check user home directories
grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    add_result "$user" "$dir"
done

# Check if any test failed
if [ ${#results[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Missing home directories"
    for result in "${results[@]}"; do
        echo "$result"
    done
fi
