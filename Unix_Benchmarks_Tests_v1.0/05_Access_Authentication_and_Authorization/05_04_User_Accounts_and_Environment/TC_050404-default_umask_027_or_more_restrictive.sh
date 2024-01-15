#!/bin/bash
TEST_TITLE="Ensure default user umask is 027 or more restrictive"
TEST_ID=050404
EXPECTED_UMASK="027"

# Function to check umask setting in a file
check_umask_setting() {
    local file=$1
    local umask_setting
    umask_setting=$(grep -E "^umask" "$file")

    if [[ -z "$umask_setting" ]]; then
        return 1 # No umask setting found
    elif [[ ! "$umask_setting" =~ umask\ 0(2[7-9]|3[0-7]) ]]; then
        echo "$TEST_ID:$TEST_TITLE:1:umask setting incorrect in $file: $umask_setting"
        return 1 # Incorrect umask setting
    fi
    return 0 # umask setting is correct
}

# Initialize failure flag
failure=0

# Check /etc/bash.bashrc
if [[ -f "/etc/bash.bashrc" ]]; then
    if ! check_umask_setting "/etc/bash.bashrc"; then
        failure=1
    fi
else
    echo "$TEST_ID:$TEST_TITLE:1:missing file /etc/bash.bashrc"
    failure=1
fi

# Check /etc/profile.d/*.sh files
profile_d_files=$(grep -l "umask" /etc/profile.d/*.sh)
if [[ -n "$profile_d_files" ]]; then
    for file in $profile_d_files; do
        if ! check_umask_setting "$file"; then
            failure=1
            break # Exit loop on first failure
        fi
    done
else
    # Check /etc/profile if no umask found in /etc/profile.d/*.sh
    if [[ -f "/etc/profile" ]]; then
        if ! check_umask_setting "/etc/profile"; then
            failure=1
        fi
    else
        echo "$TEST_ID:$TEST_TITLE:1:missing file /etc/profile"
        failure=1
    fi
fi

# Final result
if [ "$failure" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    exit 1
fi
