#!/usr/bin/env bash

test_id="SEC-USER-SHELL-TIMEOUT-900-SEC-OR-LESS-001"
test_name="Ensure default user shell timeout is 900 seconds or less"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Array for error messages
exit_status=0
max_timeout=900

# Function to check TMOUT setting in a file
check_timeout_setting() {
    local file=$1
    local timeout_setting
    timeout_setting=$(grep -E "^readonly TMOUT=" "$file" | awk -F '=' '{print $2}')

    if [[ -z "$timeout_setting" ]]; then
        test_fail_messages+=("$file does not have a TMOUT setting.")
        return 1 # No TMOUT setting found
    elif [[ "$timeout_setting" -gt "$max_timeout" ]]; then
        test_fail_messages+=("TMOUT setting too high in $file: $timeout_setting")
        return 1 # TMOUT setting too high
    fi
    return 0 # TMOUT setting is correct
}

# Check /etc/bash.bashrc
if [[ -f "/etc/bash.bashrc" ]]; then
    if ! check_timeout_setting "/etc/bash.bashrc"; then
        exit_status=1
    fi
else
    test_fail_messages+=("/etc/bash.bashrc file missing.")
    exit_status=1
fi

# Check /etc/profile.d/*.sh files
profile_d_files=$(grep -l "^readonly TMOUT=" /etc/profile.d/*.sh)
if [[ -n "$profile_d_files" ]]; then
    for file in $profile_d_files; do
        if ! check_timeout_setting "$file"; then
            exit_status=1
            break # Exit loop on first failure
        fi
    done
else
    # Check /etc/profile if no TMOUT found in /etc/profile.d/*.sh
    if [[ -f "/etc/profile" ]]; then
        if ! check_timeout_setting "/etc/profile"; then
            exit_status=1
        fi
    else
        test_fail_messages+=("/etc/profile file missing.")
        exit_status=1
    fi
fi

# Constructing a single error message
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Final result
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
