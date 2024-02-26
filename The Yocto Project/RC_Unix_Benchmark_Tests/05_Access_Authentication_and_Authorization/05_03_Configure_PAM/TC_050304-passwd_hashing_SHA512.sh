#!/bin/bash
TEST_TITLE="Ensure password hashing algorithm is SHA-512"
TEST_ID=050304

PAM_DIR="/etc/pam.d"

# Check if /etc/ssh directory exists
if [ !  -d "$PAM_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$PAM_DIR >> No such file or directory."
    exit 2
fi