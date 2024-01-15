#!/bin/bash

TEST_TITLE="Ensure no duplicate GIDs exist"
TEST_ID=060217

# Array to store test results
results=()

# Function to add test result
add_result() {
    gid="$1"
    results+=("Duplicate GID ($gid) in /etc/group")
}

# Find duplicate GIDs
cut -d: -f3 /etc/group | sort | uniq -d | while read -r gid; do
    if [ -n "$gid" ]; then
        add_result "$gid"
    fi
done

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Duplicate GIDs found"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
