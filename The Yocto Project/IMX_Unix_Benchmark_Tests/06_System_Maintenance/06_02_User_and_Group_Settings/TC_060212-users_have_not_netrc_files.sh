#!/bin/bash

TEST_TITLE="Ensure no users have .netrc files"
TEST_ID=060212

# Array to store users with .netrc files
users_with_netrc_files=()

# Check for .netrc files in user's home directories
check_netrc_files() {
    local user_home="$1"
    local username="$2"
    if [ -f "$user_home/.netrc" ]; then
        users_with_netrc_files+=("$username")
    fi
}

# Process each user's home directory
grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    check_netrc_files "$dir" "$user"
done

# Output the test results
if [ ${#users_with_netrc_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Users with .netrc files"
    for user in "${users_with_netrc_files[@]}"; do
        echo "  - $user"
    done
fi
