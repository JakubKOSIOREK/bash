#!/bin/bash

TEST_TITLE="Ensure use of privileged commands is collected"
TEST_ID=040111
AUDIT_RULES_DIR="/etc/audit/rules.d"
AUDIT_RULES_FILE="/etc/audit/audit.rules"
PARTITIONS="/" # Replace with a list of partitions if needed

# Check if the audit rules file or directory exists
if [ ! -f "$AUDIT_RULES_FILE" ] && [ ! -d "$AUDIT_RULES_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:Audit rules file not found"
    exit 2
fi

# Function to check if a specific rule for a file is in the audit rules file or directory
check_audit_rule_for_file() {
    local file=$1
    (grep -qE -- "-F path=$file -F perm=x -F auid>=1000 -F auid!=-1 -k privileged" "$AUDIT_RULES_FILE" || grep -qE -- "-F path=$file -F perm=x -F auid>=1000 -F auid!=-1 -k privileged" "$AUDIT_RULES_DIR"/*.rules)
}

# Find all files with setuid or setgid bits set and check for corresponding audit rules
missing_rules=0
while IFS= read -r file; do
    if ! check_audit_rule_for_file "$file"; then
        echo "$TEST_ID:$TEST_TITLE:1:Missing audit rule for privileged command $file"
        missing_rules=$((missing_rules + 1))
    fi
done < <(find $PARTITIONS -xdev \( -perm -4000 -o -perm -2000 \) -type f)

# Final result
if [ $missing_rules -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:One or more required audit rules for privileged commands are missing"
    exit 1
fi
