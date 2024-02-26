#!/bin/bash

TEST_TITLE="Audit system file permissions"
TEST_ID=060101

# Define an associative array with file paths as keys and expected properties (permissions and checksum) as value
declare -A file_properties=(
    # Example: ["/path/to/file"]="600 md5sum"
)

# Initialize variables to track test results
all_files_exist=true
all_permissions_match=true
all_checksums_match=true

# Iterate over the associateive array
for file in "${!file_properties[@]}"; do
    expected_properties=(${file_properties[$file]})
    expected_permissions=${expected_properties[0]}
    expected_checksum=${expected_properties[1]}

    # Check if the file exist
    if [[ ! -f "$file" ]]; then
        all_files_exist=false
        continue
    fi

    # Check file permissions
    actual_permissions=$(stat -c "%a" "$file")
    if [[ "$actual_permissions" != "$expected_permissions" ]]; then
        all_permissions_match=false
    fi

    # Check file checksum
    actual_checksum=$(md5sum "$file" | awk '{print $1}')
    if [[ "$actual_checksum" != "$expected_checksum" ]]; then
        all_checksums_match=false
    fi
done

# Check if an associative array is empty
if [ ${#file_properties[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:2: The file list has not been definied."
    exit 2
fi

# Determine the overall test result
if [[ "$all_files_exist" = true && "$all_permissions_match" = true && "$all_checksums_match" = true ]]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
elif [[ "$all_files_exist" = false ]]; then
    echo "$TEST_ID:$TEST_TITLE:1: One or more files do not exist."
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:1: One or more files have incorrect permissions or checksums."
    exit 1
fi