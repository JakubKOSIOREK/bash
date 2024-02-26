#!/bin/bash
TEST_TITLE="Ensure AIDE is installed"
TEST_ID=010401

# Check if AIDE command is available
if command -v aide >/dev/null 2>&1;then
    # AIDE is installed, test passes
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:AIDE package is not installed"
    exit 1
fi