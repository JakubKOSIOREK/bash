#!/bin/bash

TEST_TITLE="Ensure users' dot files are not group or world writable"
TEST_ID=060210

# Array to store non-compliant files
non_compliant_files=()

# Function to check dot files in user's home directory
check_dot_files() {
    local user_dir="$1"
    if [ -d "$user_dir" ]; then
        while IFS= read -r file; do
            non_compliant_files+=("$file")
        done < <(find "$user_dir" -maxdepth 1 -name ".*" -type f -perm /go+w)
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
    echo "$TEST_ID:$TEST_TITLE:1:Non-compliant dot files found"
    for file in "${non_compliant_files[@]}"; do
        echo "  - $file"
    done
fi
