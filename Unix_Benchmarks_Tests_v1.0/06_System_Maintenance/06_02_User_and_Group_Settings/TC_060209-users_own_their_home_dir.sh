#!/bin/bash

TEST_TITLE="Ensure users own their home directories"
TEST_ID=060209

# Function to check home directory ownership
check_home_dir_ownership() {
    local user="$1"
    local dir="$2"
    if [ ! -d "$dir" ]; then
        # Home directory doesn't exist
        return 1
    else
        local owner
        owner=$(stat -L -c "%U" "$dir")
        if [ "$owner" != "$user" ]; then
            # Owner of the home directory is not the user
            return 1
        fi
    fi
    return 0
}

# Array to store users with incorrect home directory ownership
incorrect_ownerships=()

# Process each user and their home directory
grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    if ! check_home_dir_ownership "$user" "$dir"; then
        incorrect_ownerships+=("$user:$dir")
    fi
done

# Check if any home directories are incorrectly owned
if [ ${#incorrect_ownerships[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Incorrect home directory ownerships found ${incorrect_ownerships[*]}"
    exit 1
fi
