#!/bin/bash

TEST_TITLE="Ensure events that modify date and time information are collected"
TEST_ID=040103
AUDIT_RULES_DIR="/etc/audit/rules.d"
AUDIT_RULES_FILE="/etc/audit/audit.rules"

# Check if the audit rules directory and file exist
if [ ! -f "$AUDIT_RULES_FILE" ] && [ ! -d "$AUDIT_RULES_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit rules file or directory not found"
    exit 2
fi

# Function to check if a specific rule is in the audit rules file or directory
check_audit_rule() {
    local rule=$1
    (grep -qE -- "$rule" "$AUDIT_RULES_FILE" || grep -qE -- "$rule" "$AUDIT_RULES_DIR"/*.rules)
}

# Define expected rules
expected_rules=(
    "-S adjtimex -k time-change"
    "-S settimeofday -k time-change"
    "-S stime -k time-change"
    "-S clock_settime -k time-change"
    "-w /etc/localtime -p wa -k time-change"
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
    echo "$TEST_ID:$TEST_TITLE:1:One or more required audit rules are missing"
    exit 1
fi
