#!/bin/bash
TEST_TITLE="Ensure default user shell timeout is 900 seconds or less"
TEST_ID=050405
MAX_TIMEOUT=900

# Function to check TMOUT setting in a file
check_timeout_setting() {
    local file=$1
    local timeout_setting
    timeout_setting=$(grep -E "^readonly TMOUT=" "$file" | awk -F '=' '{print $2}')

    if [[ -z "$timeout_setting" ]]; then
        return 1 # No TMOUT setting found
    elif [[ "$timeout_setting" -gt "$MAX_TIMEOUT" ]]; then
        echo "$TEST_ID:$TEST_TITLE:1:TMOUT setting too high in $file: $timeout_setting"
        return 1 # TMOUT setting too high
    fi
    return 0 # TMOUT setting is correct
}

# Initialize failure flag
failure=0

# Check /etc/bash.bashrc
if [[ -f "/etc/bash.bashrc" ]]; then
    if ! check_timeout_setting "/etc/bash.bashrc"; then
        failure=1
    fi
else
    echo "$TEST_ID:$TEST_TITLE:1:missing file /etc/bash.bashrc"
    failure=1
fi

# Check /etc/profile.d/*.sh files
profile_d_files=$(grep -l "^readonly TMOUT=" /etc/profile.d/*.sh)
if [[ -n "$profile_d_files" ]]; then
    for file in $profile_d_files; do
        if ! check_timeout_setting "$file"; then
            failure=1
            break # Exit loop on first failure
        fi
    done
else
    # Check /etc/profile if no TMOUT found in /etc/profile.d/*.sh
    if [[ -f "/etc/profile" ]]; then
        if ! check_timeout_setting "/etc/profile"; then
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
