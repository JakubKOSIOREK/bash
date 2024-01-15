#!/bin/bash

TEST_TITLE="Ensure no unowned files or directories exist"
TEST_ID=060111

# Get list of valid UIDs
valid_uids=$(awk -F ':' '{print $3}' /etc/passwd)

# Find files and check their ownership
unowned_files=()
while IFS= read -r file; do
    file_uid=$(stat -c "%u" "$file")
    if [[ ! " $valid_uids " =~ " $file_uid " ]]; then
        unowned_files+=("$file")
    fi
done < <(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f)

# Check for unowned files
if [ ${#unowned_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Unowned files found"
    for file in "${unowned_files[@]}"; do
        echo "  - $file"
    done
    exit 1
fi
