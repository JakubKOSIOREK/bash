#!/bin/bash

TEST_TITLE="Ensure system administrator actions (sudolog) are collected"
TEST_ID=040115
AUDIT_RULES_DIR="/etc/audit/rules.d"
AUDIT_RULES_FILE="/etc/audit/audit.rules"

# Check if the audit rules file or directory exists
if [ ! -f "$AUDIT_RULES_FILE" ] && [ ! -d "$AUDIT_RULES_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit rules file not found"
    exit 2
fi

# Extract the sudo log file location from sudoers configuration
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers /etc/sudoers.d/ 2>/dev/null| sed -e 's/.*logfile=//;s/,? .*//' | head -n 1)

# Check if the sudo log file location is extracted
if [ -z "$SUDO_LOG_FILE" ]; then
    echo "$TEST_ID:$TEST_TITLE:1:Unable to determine sudo log file location"
    exit 2
fi

# Function to check if the audit rule for the sudo log file exists
check_audit_rule_for_sudolog() {
    local logfile=$1
    (grep -qE -- "-w $logfile -p wa -k actions" "$AUDIT_RULES_FILE" || grep -qE -- "-w $logfile -p wa -k actions" "$AUDIT_RULES_DIR"/*.rules)
}

# Check for the expected audit rule
if ! check_audit_rule_for_sudolog "$SUDO_LOG_FILE"; then
    echo "$TEST_ID:$TEST_TITLE:1:Missing audit rule for sudo log file $SUDO_LOG_FILE"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
fi
