#!/bin/bash

TEST_TITLE="Ensure no world writable files exist"
TEST_ID=060110

# Find world writable files
files=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)

if [ -z "$files" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:World writable files found"
    exit 1
fi
