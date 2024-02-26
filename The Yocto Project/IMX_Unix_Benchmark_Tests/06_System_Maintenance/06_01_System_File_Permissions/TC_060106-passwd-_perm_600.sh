#!/bin/bash

TEST_TITLE="Ensure permissions on /etc/passwd- are configured"
TEST_ID=060106
FILE="/etc/passwd-"
EXPECTED_PERMISSIONS=600
USER="root"
GROUP="$USER"  # Setting group to be the same as the user

# Convert permissions to a numeric value for comparison
octal_to_numeric() {
    echo "$((8#$1))"
}

# Function to check file permissions, owner, and group
check_file() {
    local file=$1
    local expected_permissions=$2
    local expected_user=$3
    local expected_group=$4

    # Check if file exist
    if [ ! -f "$file" ]; then
        echo "$TEST_ID:$TEST_TITLE:2:No such file or directory"
    return 2
    fi

    local current_permissions=$(stat -c "%a" "$file")
    local numeric_current_permissions=$(octal_to_numeric "$current_permissions")
    local numeric_expected_permissions=$(octal_to_numeric "$expected_permissions")
    local current_user=$(stat -c "%U" "$file")
    local current_group=$(stat -c "%G" "$file")

    if [ "$numeric_current_permissions" -le "$numeric_expected_permissions" ]; then
        if [ "$current_user" != "$expected_user" ]; then
            echo "$TEST_ID:$TEST_TITLE:1:Incorrect owner, found $current_user, expected $expected_user"
            return 1
        elif [ "$current_group" != "$expected_group" ]; then
            echo "$TEST_ID:$TEST_TITLE:1:Incorrect group, found $current_group, expected $expected_group"
            return 1
        fi
        echo "$TEST_ID:$TEST_TITLE:0"
        return 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:Permissions are less restrictive than expected. Current-> $current_permissions, expected-> $expected_permissions"
        return 1
    fi
}

# Check file permissions, owner, and group
check_file "$FILE" "$EXPECTED_PERMISSIONS" "$USER" "$GROUP"
exit $?
