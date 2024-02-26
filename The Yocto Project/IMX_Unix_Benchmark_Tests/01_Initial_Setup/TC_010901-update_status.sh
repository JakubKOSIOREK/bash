#!/bin/bash

TEST_TITLE="Ensure updates, patches, and additional security software are installed"
TEST_ID=010901

APT_GET_COMMAND="apt-get -s upgrade"

# Check for available updates, suppressing warnings
updates=$($APT_GET_COMMAND 2>/dev/null | grep "^Inst" | wc -l)

# Check if updates are available
if [ "$updates" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0" # Pass
    exit 0
else
    # Print the available updates for detailed information
    available_updates=$($APT_GET_COMMAND 2>/dev/null | grep "^Inst")
    echo "$TEST_ID:$TEST_TITLE:1:$updates updates available:\n$available_updates" # Fail with additional info
    exit 1
fi
