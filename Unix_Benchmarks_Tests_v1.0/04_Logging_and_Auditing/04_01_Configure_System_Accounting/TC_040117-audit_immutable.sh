#!/bin/bash

TEST_TITLE="Ensure the audit configuration is immutable"
TEST_ID=040117
AUDIT_RULES_DIR="/etc/audit/rules.d"

# Check if the audit rules directory exists
if [ ! -d "$AUDIT_RULES_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit rules directory not found"
    exit 2
fi

# Function to check if the audit rules are immutable
check_immutable_flag() {
    local last_line=$(grep "^\s*[^#]" "$AUDIT_RULES_DIR"/*.rules | tail -1)
    if [[ "$last_line" == *"-e 2"* ]]; then
        return 0 # Immutable flag is present
    else
        return 1 # Immutable flag is missing
    fi
}

# Check for the immutable flag
if check_immutable_flag; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Missing immutable flag (-e 2) in audit rules"
    exit 1
fi
