#!/bin/bash

TEST_TITLE="Ensure mail transfer agent is configured for local-only mode"
TEST_ID=020215

# Function to check if a mail transfer agent is configured for local-only mode
check_mta() {
    # Check for MTA listening on non-loopback address for IPv4
    # Ignoring errors from netstat command itself
    if netstat -an 2>/dev/null | grep ":25[[:space:]]" | grep -vE "127.0.0.1:25"; then
        return 1 # Fail if any non-loopback (non-127.0.0.1) address is found
    fi

    # Optionally check for IPv6 if your system support it
    # Comment out or remove this block if your system does not support IPv6
    #if netstat -an | grep ":25[[:space:]]" | grep -vE "::1:25"; then
    #    return 1 # Fail if any non-loopback (::1) IPv6 address is found
    #fi
    
    return 0 # Pass if only loopback addresses are found
}

# Check MTA configuration
if check_mta; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Mail transfer agent is not configured for local-only mode"
fi
