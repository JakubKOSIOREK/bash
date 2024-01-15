#!/bin/bash

TEST_TITLE="Ensure no ungrouped files or directories exist"
TEST_ID=060112

# Get list of valid GIDs
valid_gids=$(awk -F ':' '{print $3}' /etc/group)

# Find files and check their group ownership
ungrouped_files=()
while IFS= read -r file; do
    file_gid=$(stat -c "%g" "$file")
    if [[ ! " $valid_gids " =~ " $file_gid " ]]; then
        ungrouped_files+=("$file")
    fi
done < <(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f)

# Check for ungrouped files
if [ ${#ungrouped_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Ungrouped files found"
    for file in "${ungrouped_files[@]}"; do
        echo "  - $file"
    done
    exit 1
fi
