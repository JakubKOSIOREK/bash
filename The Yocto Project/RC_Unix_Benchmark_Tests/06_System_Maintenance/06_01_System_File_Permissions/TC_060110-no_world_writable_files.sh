#!/bin/bash

TEST_TITLE="Ensure no world writable files exist"
TEST_ID=060110

files_list=""

# Find world writable files
df -P | awk 'NR!=1 {print $6}' | while read mountpoint; do
    found_files=$(find "$mountpoint" -xdev -type f -perm -0002 -print)
    if [ -n "$found_files" ]; then
        files_list="$files_list$found_files\n"
    fi
done

if [ -z "$files_list" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:World writable files found >> $files_list"
    exit 1
fi
