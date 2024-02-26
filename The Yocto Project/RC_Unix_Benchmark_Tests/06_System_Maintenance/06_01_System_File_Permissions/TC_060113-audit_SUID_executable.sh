#!/bin/bash

TEST_TITLE="Audit SUID executables"
TEST_ID=060113

#echo "$TEST_ID:$TEST_TITLE:2:Work in progres"
#exit 2


# Expected list of SUID executables
EXPECTED_LIST=()


# Getting actual output from the find command
#actual_list=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000)
actual_list=$(find / -perm 4000 2>/dev/null)

# Check for discrepancies
extra_files=()
while IFS= read -r file; do
    if [[ ! " ${EXPECTED_LIST[@]} " =~ " ${file} " ]]; then
        extra_files+=("$file")
    fi
done <<< "$actual_list"

# Output the result
if [ ${#extra_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Unexpected SUID files found -> ${extra_files[*]}"
    exit 1
fi