#!/bin/bash
TEST_TITLE="Ensure sudo or sudo-ldap is installed"
TEST_ID=010301

# Check if sudo command is available

if command -v sudo >/dev/null 2>&1; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:No sudo packages installed."
    exit 1
fi