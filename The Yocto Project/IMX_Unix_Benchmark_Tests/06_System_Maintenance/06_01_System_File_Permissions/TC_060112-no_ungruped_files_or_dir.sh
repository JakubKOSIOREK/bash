#!/bin/bash

TEST_TITLE="Ensure no ungrouped files or directories exist"
TEST_ID=060112

# Declare an array to hold user IDs
declare -a gid_array

# Fill the gid_array with UIDs from /etc/group
while IFS=':' read -r _ _ gid _;do
    gid_array+=("$gid")
done < /etc/group

# Specyfi the search path, "/" means the entire filesystem
search_path="/"

# Use find command to search for files and directories, and process them one by one
find "$search_path" \( -type f -o -type d \) -print0 | while IFS= read -r -d $'\0' file; do
    file_gid=$(stat -c "%u" "$file")

    # Check if the file UID is not in the gid_array
    if [[ ! "$gid_array[@]" =~ "$file_gid" ]];then
        echo "$TEST_ID:$TEST_TITLE:1:No group with GID=$file_gid -> $file"
        exit 1
    fi
done

echo "$TEST_ID:$TEST_TITLE:0"
exit 0

