#!/bin/bash

TEST_TITLE="Ensure shadow group is empty"
TEST_ID=060220

GROUP_FILE="/etc/group"

# Check if file exists
if [[ ! -f "$GROUP_FILE" ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$GROUP_FILE >> No such file or directory."
    exit 2
fi

# Array to store test results
results=()

# Function to add test result
add_result() {
    message="$1"
    results+=("$message")
}

# Check if shadow group is empty in /etc/group
if grep -q "^shadow:[^:]*:[^:]*:[^:]+:" /etc/group; then
    add_result "Shadow group is not empty in /etc/group."
fi

# Get shadow group's GID
shadow_gid=$(grep "^shadow:" /etc/group | cut -d: -f3)

# Check if any user in /etc/passwd has shadow group as their primary group
if [ -n "$shadow_gid" ] && awk -F: -v gid="$shadow_gid" '($4 == gid) { print }' /etc/passwd | grep -q .; then
    add_result "There are users with the shadow group as their primary group in /etc/passwd."
fi

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Issues found"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
