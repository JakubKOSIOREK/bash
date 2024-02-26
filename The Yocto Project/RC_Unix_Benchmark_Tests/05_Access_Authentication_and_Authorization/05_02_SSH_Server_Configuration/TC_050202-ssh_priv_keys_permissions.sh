#!/bin/bash
TEST_TITLE="Ensure permissions on SSH private host key files are configured"
TEST_ID=050202
SSH_DIR="/etc/ssh"
EXPECTED_PERMISSIONS="600"
EXPECTED_OWNER=0  # UID of root
EXPECTED_GROUP=0  # GID of root

# Check if /etc/ssh directory exists
if [ !  -d "$SSH_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SSH_DIR >> No such file or directory."
    exit 2
fi
