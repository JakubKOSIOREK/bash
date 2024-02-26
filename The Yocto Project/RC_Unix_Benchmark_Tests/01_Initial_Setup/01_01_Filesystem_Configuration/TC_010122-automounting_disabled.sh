#!/bin/bash

TEST_TITLE="Disable Automounting"
TEST_ID=010122

# Check if autofs command is available
if command -v autofs >/dev/null 2>&1; then
    echo "$TEST_ID:$TEST_TITLE:1:Automounting might be enabled"
    exit 1
else
    # If `autofs` command is not available, assume automounting is not enabled
    echo "$TEST_ID:$TEST_TITLE:0" 
    exit 0
fi
