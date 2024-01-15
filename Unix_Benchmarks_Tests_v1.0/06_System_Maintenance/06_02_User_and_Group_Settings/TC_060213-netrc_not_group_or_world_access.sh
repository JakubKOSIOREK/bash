#!/bin/bash

TEST_TITLE="Ensure users' .netrc Files are not group or world accessible"
TEST_ID=060213

# Array to store test results
results=()

# Function to add test result
add_result() {
    message="$1"
    results+=("$message")
}

# Process each user and their home directory
grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    if [ -d "$dir" ] && [ -f "$dir/.netrc" ]; then
        file="$dir/.netrc"
        fileperm=$(ls -ld "$file" | cut -f1 -d" ")
        for i in {5..10}; do
            case $i in
                5) perm="Group Read" ;;
                6) perm="Group Write" ;;
                7) perm="Group Execute" ;;
                8) perm="Other Read" ;;
                9) perm="Other Write" ;;
                10) perm="Other Execute" ;;
            esac
            if [ "$(echo $fileperm | cut -c$i)" != "-" ]; then
                add_result "$perm set on $file"
            fi
        done
    fi
done

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions issue found for .netrc files"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
