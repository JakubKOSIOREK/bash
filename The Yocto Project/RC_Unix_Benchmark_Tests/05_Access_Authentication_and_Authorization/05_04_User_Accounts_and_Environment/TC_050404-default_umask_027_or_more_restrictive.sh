#!/bin/bash

TEST_TITLE="Ensure default user umask is 027 or more restrictive"
TEST_ID=050404
EXPECTED_UMASK="0027" # Expected umask value with leading zero for formatconsistency

# define configuration files to check
CONFIG_FILES=(
    "/etc/profile"
    "/etc/bash.bashrc"
    "/etc/profile.d/*.sh"
)

# Check current umask setting
current_umask=$(umask)

if [[ "$current_umask" != "$EXPECTED_UMASK" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Current umask is $current_umask, expected $EXPECTED_UMASK"
    current_fail=true
else
    echo "$TEST_ID:$TEST_TITLE:0"
    current_fail=false
fi

# Initialize flags
files_fail=false
missing_files=0
incorrect_settings=0

# Check umask settings in configuration files
for file in "${CONFIG_FILES[@]}"; do
    if ls $file 1>/dev/null 2>&1; then
        for f in $file; do
            if ! grep -qE "^umask\s+$EXPECTED_UMASK" "$f"; then
                echo "$TEST_ID:$TEST_TITLE:3:Umask settings incorrect or missing in $f"
                incorrect_settings=$((incorrect_setting + 1))
                files_fail=true
            fi
        done
    else
        echo "$TEST_ID:$TEST_TITLE:3:Configuration file not found -> $f"
        missing_files=$((missing_files + 1))
    fi
done

# Output warnings for missing files or incorrect settings
if [ $missing_files -ne 0 ] || [ $incorrect_settings -ne 0 ]; then
    exit 3
fi

# Final result
if ! current_fail && ! $files_fail; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    exit 1
fi
