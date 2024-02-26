#!/bin/bash

TEST_TITLE="Ensure the audit configuration is immutable"
TEST_ID=040117
AUDIT_RULES_DIR="/etc/audit/rules.d"
AUDIT_RULES_FILE="/etc/audit/audit.rules"

# Check if the audit rules file or directory exists
if [ ! -f "$AUDIT_RULES_FILE" ] && [ ! -d "$AUDIT_RULES_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit rules file not found"
    exit 2
fi

# Function to check if the audit rules are immutable
check_immutable_flag() {

    # Check in individual rules files
    local last_line_dir=$(grep "^\s*[^#]" "$AUDIT_RULES_DIR"/*.rules | tail -1)

    # Check in main audit rules file
    local last_line_file=$(grep "^\s*[^#]" "$AUDIT_RULES_FILE"/*.rules | tail -1)

    if [[ "$last_line_dir" == *"-e 2"* ]] || [[ "$last_line_file" == *"-e 2"* ]]; then
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
