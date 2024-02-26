#!/bin/bash

TEST_TITLE="Ensure outbound and established connections are configured"
TEST_ID=0305040103

# Define the expected rules
EXPECTED_RULES=(
    "-A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT"
    "-A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT"
    "-A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT"
    "-A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT"
    "-A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT"
    "-A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT"
)

# Check if iptables is available on the system
if ! command -v iptables >/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:2:iptables is not installed" # NOT IMPLEMENTED
    exit 2
fi

# Check if ip_table module is loaded
if ! modprobe ip_tables 2>/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:1:ERROR - could not insert 'ip_tables', Invalid argument" # FAIL
    exit 1
fi


# Initialize a flag to track if all rules pass
all_rules_pass=true

# Check each expected rule
for rule in "${EXPECTED_RULES[@]}"; do
    # Use iptables-save for checking
    if ! iptables-save | grep -qE "^$rule\$"; then
        echo "$TEST_ID:$TEST_TITLE:1:Rule missing or incorrect -> $rule." # FAIL
        all_rules_pass=false
    fi
done

# Determine the overall result based on the all_rules_pass flag
if $all_rules_pass; then
    echo "$TEST_ID:$TEST_TITLE:0" # PASS
    exit 0
else
    exit 1
fi
