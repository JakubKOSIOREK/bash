#!/bin/bash

TEST_TITLE="Ensure auditd is installed"
TEST_ID=04010101

# Check if auditd is installed
if command -v auditd >/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:0" # PASS
else
    echo "$TEST_ID:$TEST_TITLE:1:No auditd packages installed." # FAIL
fi