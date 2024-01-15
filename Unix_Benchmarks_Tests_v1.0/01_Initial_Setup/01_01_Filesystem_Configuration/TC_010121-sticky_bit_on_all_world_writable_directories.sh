#!/bin/bash

TEST_TITLE="Ensure sticky bit is set on all world-writable directories"
TEST_ID=010121

# Get all local filesystem directories
directories=$(df --local -P | awk '{if (NR!=1) print $6}')

# Initialize the test result as pass
TEST_RESULT=0

# Check each directory
for dir in $directories
do
    # Find world writable directories with sticky bit not set
    result=$(find "$dir" -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null)
    
    # If result is not empty, then test fails
    if [[ ! -z $result ]]
    then
        echo "$TEST_ID:$TEST_TITLE:1:World-writable directories without sticky bit found"
        TEST_RESULT=1
        break
    fi
done

# Final result
if [ "$TEST_RESULT" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    exit 1
fi
