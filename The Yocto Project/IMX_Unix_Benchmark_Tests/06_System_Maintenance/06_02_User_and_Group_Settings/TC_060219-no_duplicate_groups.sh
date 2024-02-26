#!/bin/bash

TEST_TITLE="Ensure no duplicate group names exist"
TEST_ID=060219

# Array to store test results
results=()

# Function to add test result
add_result() {
    groupname="$1"
    results+=("Duplicate group name ($groupname)")
}

# Find duplicate group names
cut -d: -f1 /etc/group | sort | uniq -d | while read groupname; do
    if [ -n "$groupname" ]; then
        add_result "$groupname"
    fi
done

# Output test results and check if any test failed
if [ ${#results[@]} -ne 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Duplicate group names found"
    for result in "${results[@]}"; do
        echo "  - $result"
    done
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
