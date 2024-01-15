#!/bin/bash

TEST_TITLE="Audit SGID executables"
TEST_ID=060114

# Expected list of SGID executables
EXPECTED_LIST=(
    /usr/bin/at
    /usr/bin/crontab
)

# Getting actual output from the find command
actual_list=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000)

# Check for discrepancies
extra_files=()
while IFS= read -r file; do
    if [[ ! " ${EXPECTED_LIST[*]} " =~ " ${file} " ]]; then
        extra_files+=("$file")
    fi
done <<< "$actual_list"

# Output the result
if [ ${#extra_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Unexpected SGID files found"
    for file in "${extra_files[@]}"; do
        echo "  - $file"
    done
    exit 1
fi
