#!/bin/bash

TEST_TITLE="Ensure no unowned files or directories exist"
TEST_ID=060111

# Declare an array to hold user IDs
declare -a uid_array

# Fill the uid_array with UIDs from /etc/passwd
while IFS=':' read -r _ _ uid _;do
    uid_array+=("$uid")
done < /etc/passwd

# Specyfi the search path, "/" means the entire filesystem
search_path="/"

# Use find command to search for files and directories, and process them one by one
find "$search_path" \( -type f -o -type d \) -print0 | while IFS= read -r -d $'\0' file; do
    file_uid=$(stat -c "%u" "$file")

    # Check if the file UID is not in the uid_array
    if [[ ! "$uid_array[@]" =~ "$file_uid" ]];then
        echo "$TEST_ID:$TEST_TITLE:1:No user with UID=$file_uid -> $file"
        exit 1
    fi
done

echo "$TEST_ID:$TEST_TITLE:0"
exit 0
