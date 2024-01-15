#!/bin/bash
TEST_TITLE="Ensure password hashing algorithm is SHA-512"
TEST_ID=050304

# Function to check if sha512 option is present for pam_unix.so
check_sha512_option() {
    local config_line=$1
    if [[ "$config_line" =~ pam_unix\.so ]]; then
        if [[ "$config_line" =~ sha512 ]]; then
            return 0
        else
            return 1
        fi
    fi
    return 2
}

# Check for pam_unix.so configuration in common-password
config_lines=$(grep -E '^\s*password\s+(\S+\s+)+pam_unix\.so\s+' /etc/pam.d/common-password)

# If pam_unix.so configuration is not found
if [ -z "$config_lines" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:pam_unix.so not configured in /etc/pam.d/common-password"
    exit 1
fi

# Check each line for sha512 option
while read -r line; do
    if ! check_sha512_option "$line"; then
        echo "$TEST_ID:$TEST_TITLE:1:SHA-512 hashing not configured for pam_unix.so. Found line: $line"
        exit 1
    fi
done <<< "$config_lines"

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
