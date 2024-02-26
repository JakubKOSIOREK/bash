#!/bin/bash

TEST_TITLE="Ensure root PATH Integrity"
TEST_ID=060207

# Initialize a flag to track if the test passes or fails
test_failed=false

# Array to store error messages
error_messages=()

# Check for empty directory in PATH
if echo $PATH | grep -q "::" ; then
    error_messages+=("Empty Directory in PATH (::)")
    test_failed=true
fi

# Check for trailing : in PATH
if echo $PATH | grep -q ":$" ; then
    error_messages+=("Trailing : in PATH")
    test_failed=true
fi

# Check each directory in PATH
for x in $(echo $PATH | tr ":" " ") ; do
    if [ -d "$x" ] ; then
        owner=$(ls -ldH "$x" | awk '{print $3}')
        if [ "$owner" = "root" ]; then
            output=$(ls -ldH "$x" | awk ' 
                substr($1,6,1) != "-" {print $9 " is group writable"; exit 1}
                substr($1,9,1) != "-" {print $9 " is world writable"; exit 1}
            ')
            if [ $? -eq 1 ]; then
                error_messages+=("$output")
                test_failed=true
            fi
        fi
    else
        error_messages+=("$x is not a directory")
        test_failed=true
    fi
done

# Check if the test failed
if [ "$test_failed" = false ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    formatted_errors=$(IFS=,; echo "${error_messages[*]}")
    echo "$TEST_ID:$TEST_TITLE:1:$formatted_errors"
fi
