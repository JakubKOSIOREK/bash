#!/bin/bash

TEST_TITLE="Ensure successful file system mounts are collected"
TEST_ID=040112
AUDIT_RULES_DIR="/etc/audit/rules.d"
AUDIT_RULES_FILE="/etc/audit/audit.rules"
ARCH=$(uname -m)

# Check if the audit rules file or directory exists
if [ ! -f "$AUDIT_RULES_FILE" ] && [ ! -d "$AUDIT_RULES_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit rules file or directory not found"
    exit 2
fi

# Function to check if a specific rule is in the audit rules file or directory
check_audit_rule() {
    local rule=$1
    (grep -qE -- "$rule" "$AUDIT_RULES_FILE" || grep -qE -- "$rule" "$AUDIT_RULES_DIR"/*.rules)
}

# Define expected rules for monitoring successful file system mounts
expected_rules=(
    "-a always,exit -F arch=b$([ "$ARCH" = "x86_64" ] && echo 64 || echo 32) -S mount -F auid>=1000 -F auid!=4294967295 -k mounts"
)

# Check for expected rules
missing_rules=0
for rule in "${expected_rules[@]}"; do
    if ! check_audit_rule "$rule"; then
        echo "$TEST_ID:$TEST_TITLE:1:Missing audit rule $rule"
        missing_rules=$((missing_rules + 1))
    fi
done

# Final result
if [ $missing_rules -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:One or more required audit rules for filesystem mounts are missing"
    exit 1
fi
