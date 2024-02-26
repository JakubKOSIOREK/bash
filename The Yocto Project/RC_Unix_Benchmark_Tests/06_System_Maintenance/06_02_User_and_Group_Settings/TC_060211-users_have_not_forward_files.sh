#!/bin/bash

TEST_TITLE="Ensure no users have .forward files"
TEST_ID=060211

# Array to store users with .forward files
users_with_forward_files=()

# Check for .forward files in user's home directories
check_forward_files() {
    local user_home="$1"
    local username="$2"
    if [ -f "$user_home/.forward" ]; then
        users_with_forward_files+=("$username")
    fi
}

# Process each user's home directory
grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    check_forward_files "$dir" "$user"
done

# Output the test results
if [ ${#users_with_forward_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Users with .forward files"
    for user in "${users_with_forward_files[@]}"; do
        echo "  - $user"
    done
fi
