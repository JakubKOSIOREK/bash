#!/bin/bash

TEST_TITLE="Ensure users' dot files are not group or world writable"
TEST_ID=060210

# Array to store non-compliant files
non_compliant_files=()

# Function to check dot files in user's home directory
check_dot_files() {
    local user_dir="$1"

    if [ -d "$user_dir" ]; then
        local files=$(find "$user_dir" -maxdepth 1 -name ".*" -type f -perm go+w)

        if [ -n "$files" ]; then
            non_compliant_files+="$files\n"
        fi
    fi
}

# Process each user's home directory
grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $6 }' | while read -r dir; do
    check_dot_files "$dir"
done

# Check if any non-compliant files are found
if [ ${#non_compliant_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Non-compliant dot files found >> $non_compliant_files[@]"
fi
