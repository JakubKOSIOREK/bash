#!/bin/bash
TEST_TITLE="Ensure default user shell timeout is 900 seconds or less"
TEST_ID=050405
MAX_TIMEOUT=900

# Define an array of configuration files to check for the TMOUT setting
CONFIG_FILES=(
    "/etc/bash.bashrc"
    "/etc/profile"
)

# Initialize flags to track the presence of TMOUT setting and its correctness
tmout_found=false
incorrect_setting=false

# Loop throught each configuration file
for file in "${CONFIG_FILES[@]}"; do
    # Check if the file exists and contains the TMOUT setting
    if [[ -f "$file" && $(grep -q "^readonly TMOUT=" "$file") ]]; then
        tmout_found=true
        # Extract the value of TMOUT setting from the file
        tmout_value=$(grep "^readonly TMOUT=" "$file" | cut -d'=' -f2)
        # Check if the extracted TMOUT value exceeds the maximum allowed timeout
        if [[ "$tmout_value" -gt "$MAX_TIMEOUT" ]]; then
            incorrect_setting=true
            echo "$TEST_ID:$TEST_TITLE:1:TMOUT setting is not set or too high in $file"
            exit 1
        fi
    fi
done

# Output the final result based on the check
if ! $tmout_found; then
    echo "$TEST_ID:$TEST_TITLE:2:TMOUT setting not found in configuration files."
    exit 2
elif ! $incorrect_setting; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi