#!/bin/bash

TEST_TITLE="Ensure no users have .rhosts files"
TEST_ID=060214

# Array to store test results
results=()

# Function to add test result
add_result() {
    message="$1"
    results+=("$message")
}

# Process each user and their home directory
grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    if [ -d "$dir" ] && [ -f "$dir/.rhosts" ]; then
        add_result ".rhosts file in $dir for user $user."
    fi
done

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:.rhosts files found"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
