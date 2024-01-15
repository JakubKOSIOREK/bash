#!/bin/bash

TEST_TITLE="Ensure all groups in /etc/passwd exist in /etc/group"
TEST_ID=060215

# Array to store test results
results=()

# Function to add test result
add_result() {
    message="$1"
    results+=("$message")
}

# Iterate over each unique group ID in /etc/passwd
while IFS=: read -r _ _ _ gid; do
    if ! grep -q ":x:$gid:" /etc/group; then
        add_result "Group ID $gid is referenced by /etc/passwd but does not exist in /etc/group"
    fi
done < <(cut -d: -f4 /etc/passwd | sort -u)

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Missing groups in /etc/group"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
