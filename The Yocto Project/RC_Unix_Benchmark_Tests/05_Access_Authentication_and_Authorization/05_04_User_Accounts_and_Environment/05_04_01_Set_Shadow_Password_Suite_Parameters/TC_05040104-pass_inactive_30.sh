#!/bin/bash
TEST_TITLE="Ensure inactive password lock is 30 days or less"
TEST_ID=05040104

# Check for the xinetd executable
if ! command -v useradd >/dev/null 2>&1;then
    echo "$TEST_ID:$TEST_TITLE:2:Function is not available."
    exit 1
fi
